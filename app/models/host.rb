class Host
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  field :ip, type: String
  field :port, type: String
  field :check_time, type: DateTime
  field :server, type: String, default: "Unknown"
  field :banner, type: String
  field :title, type: String

  def as_indexed_json(options={})
    as_json(only: [:ip, :port, :server, :title])
  end

  def self.zmap_read
    parsed_num = 0
    begintime = Time.now

    Dir.glob("#{ZMAP_LOG_PATH}/#{Time.now.strftime("%Y%m%d")}-*.log").each do |log|
      /\d*-(\d+).log/ =~ log
      port = $1

      File.readlines(log)[0..-2].each do |line|
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
      end
    end

    tastetime = Time.now() - begintime
  end
end
