class ParseController < ApplicationController
  def whatweb_read
    parsed_num = 0
    begintime = Time.now

    File.open('tmp/whatweb_logs/b').each_line do |line|
      line_hash = JSON.parse(line)
      if line_hash['http_status'] == 200
        #create a new or find the old
        find = Website.where(target: "#{line_hash['target']}").first
        new_website = find ? find : Website.new

        #save from whatweb_log
        new_website.target = line_hash['target']
        new_website.ip = line_hash['plugins']['IP']['string'].first
        new_website.os = line_hash['plugins']['HTTPServer']['os']
        new_website.http_server = line_hash['plugins']['HTTPServer']['string'].first
        new_website.port =URI(line_hash['target']).port

        
        new_website.headers = get_headers(line_hash['plugins']['HTTP-Headers']['string'])

        new_website.title = line_hash['plugins']['Title']['string'].first
        new_website.keywords = line_hash['plugins']['Meta-Keywords']['string'].first.split(',') if line_hash['plugins']['Meta-Keywords']
        new_website.description = line_hash['plugins']['Meta-Description']['string'].first if line_hash['plugins']['Meta-Description']

        new_website.check_time = Time.now
        new_website.save

        parsed_num += 1
      end
    end

    totaltime = Time.now() - begintime

    respond_to do |format|
      format.json { render json: num}
      format.html { render json: {"succeed": parsed_num, "total": totaltime}}
    end
  end

  def nmap_read
  end

  private

    def get_headers(array)
        the_headers = ""
        array.each do |key,value|
          the_headers += "#{key}: #{value}\n"
        end

        the_headers
    end

end
