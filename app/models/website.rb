class Website
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  field :target, type: String
  field :port, type: String
  field :webapp, type: String
  field :server, type: String, default: "Unknown"
  field :os, type: String
  field :frontend, type: String
  field :headers, type: String
  field :title, type: String
  field :keywords, type: Array
  field :description, type: String
  field :ip, type: String
  field :check_time, type: DateTime

  def as_indexed_json(options={})
    as_json(except: [:target, :_id])
  end

  def self.whatweb_read
      parsed_num = 0
      begintime = Time.now

      File.open("#{WHATWEB_LOG_PATH}/#{Time.now.strftime("%Y%m%d")}.log").each_line do |line|
        line_hash = JSON.parse(line)
        #create a new or find the old
        find = Website.where(target: "#{line_hash['target']}").first
        new_website = find ? find : Website.new

        #save from whatweb_log
        new_website.target = line_hash['target']
        new_website.ip = line_hash['plugins']['IP']['string'].first 
        new_website.os = line_hash['plugins']['HTTPServer']['os'].first if line_hash['plugins']['HTTPServer'] and line_hash['plugins']['HTTPServer']['os']
        new_website.server = line_hash['plugins']['HTTPServer']['string'].first if line_hash['plugins']['HTTPServer']
        new_website.port =URI(line_hash['target']).port
        new_website.headers = get_headers(line_hash['plugins']['HTTP-Headers']['string'])
        new_website.title = line_hash['plugins']['Title']['string'].first if line_hash['plugins']['Title']
        new_website.keywords = line_hash['plugins']['Meta-Keywords']['string'].first.split(',') if line_hash['plugins']['Meta-Keywords']
        new_website.description = line_hash['plugins']['Meta-Description']['string'].first if line_hash['plugins']['Meta-Description']
        new_website.check_time = Time.now

        new_website.save
        parsed_num += 1
      end

      totaltime = Time.now() - begintime
  end

  private
    def self.get_headers(array)
        the_headers = ""
        array.each do |key,value|
          the_headers += "#{key}: #{value}\n"
        end

        the_headers
    end
end
