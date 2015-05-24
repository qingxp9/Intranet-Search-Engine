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
        new_website.os = line_hash['plugins']['HTTPServer']['os']
        new_website.http_server = line_hash['plugins']['HTTPServer']['string']
        new_website.port =URI(line_hash['target']).port

        new_website.headers = line_hash['plugins']['HTTP-Headers']['string']
        new_website.title = line_hash['plugins']['Title']['string']
        new_website.keywords = line_hash['plugins']['Meta-Keywords']['string'] if line_hash['plugins']['Meta-Keywords']
        new_website.description = line_hash['plugins']['Meta-Description']['string'] if line_hash['plugins']['Meta-Description']

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
end
