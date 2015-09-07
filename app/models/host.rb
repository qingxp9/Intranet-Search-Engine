class Host
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  field :ip, type: String
  field :port, type: String
  field :check_time, type: DateTime
  field :server, type: String
  field :banner, type: String
  field :title, type: String

  def as_indexed_json(options={})
    as_json(only: [:ip, :port, :server, :title, :banner])
  end

  def self.zmap_read
    parsed_num = 0
    begintime = Time.now

    Dir.glob("#{ZMAP_LOG_PATH}/#{Time.now.strftime("%Y%m%d")}-*.*").each do |log|
      /-(\d+)\.\w+$/ =~ log
      port = $1

      File.readlines(log).each do |line|
        line_hash = JSON.parse line
        next if line_hash["error"]
        find = Host.where(ip: line_hash["ip"], port: port).first
        host = find ? find : Host.new

        host.ip = line_hash["ip"]
        host.port = port
        host.check_time = Time.now

        host.banner = line_hash["data"]["read"]
        #Regular identify
        /Server:(.*?)\r\n/ =~ host.banner
        host.server = $1
        /<title>(.*?)<\/title>/ =~ host.banner
        host.title = $1

        host.save
        parsed_num += 1
        puts parsed_num if parsed_num % 100 == 0
      end
    end

    tastetime = Time.now() - begintime
  end

  def self.search(query)
    should_list = []
    must_list = []

    query.split.each do |x|
     if x.count(":") == 0
       should_list = [
         { match: { server: x}},
         { match: { banner: x}},
         { match: { title: x}},
         { match: { ip: x}}
       ]
     elsif x.split(":").first == "ip"
         #if x.count("/") == 0
           must_list << {
             range: {
               ip: {
                 from: x.split(":").last,
                 to: x.split(":").last
               }
             }
           }
         #else
         #end
     else
       must_list << { match: { "#{x.split(":").first}": x.split(":").last } }
     end
    end

    tmp = {
            size: 50,
            query: {
              bool: {
                should: should_list,
                must: must_list
              }
            },
            highlight: {
              pre_tags: ['<em>'],
              post_tags: ['</em>'],
              fields: {
                title: {},
                ip: {},
                banner: {},
                server: {}
              }
            }
          }

    __elasticsearch__.search(tmp)

  end
end
