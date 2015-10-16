class Intranet
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  field :belong, type: String
  field :ip, type: String
  field :port, type: String
  field :check_time, type: DateTime
  field :server, type: String
  field :title, type: String
  field :banner, type: String

  def as_indexed_json(options={})
    as_json(only: [:ip, :port, :server, :title, :belong, :banner])
  end

  def self.zmap_read(pathname, port, belong)
    parsed_num = 0
    begintime = Time.now

    File.readlines(pathname).each do |line|
      begin
        line_hash = JSON.parse line
      rescue
        next
      end

      next if line_hash["error"]

      #find a old one
      find = Intranet.where(ip: line_hash["ip"], port: port, belong: belong).first
      intranet = find ? find : Intranet.new

      intranet.ip = line_hash["ip"]
      intranet.port = port
      intranet.belong = belong
      intranet.check_time = Time.now
      intranet.banner = line_hash["data"]["read"]

      #Regular identify
      /Server:(.*?)\r\n/ =~ intranet.banner
      intranet.server = $1
      /<title>(.*?)<\/title>/ =~ intranet.banner
      intranet.title = $1

      intranet.save

      #output the process number
      parsed_num += 1
      puts parsed_num if parsed_num % 100 == 0
    end

    tastetime = Time.now() - begintime
    puts "Intranet import #{parsed_num} ,Cost time: #{tastetime}"
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
         { match: { belong: x}},
         { match: { ip: x}},
         { match: { port: x}}
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
            }
          }

    __elasticsearch__.search(tmp)

  end
end
