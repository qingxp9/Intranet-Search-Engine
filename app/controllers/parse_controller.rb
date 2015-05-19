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
        #get target website http response
        #http_res = RestClient.get(line_hash['target'])

        #save from whatweb_log
        new_website.target = line_hash['target']
        new_website.os = line_hash['plugins']['HTTPServer']['os']
        new_website.http_server = line_hash['plugins']['HTTPServer']['string']
        new_website.port =URI(line_hash['target']).port

        #save from http response
        #new_website.body = http_res
        #new_website.title = $1 if /<title>(.*?)<\/title>/.match(http_res)
        #new_website.description = $1 if /"description" content="(.*?)"/.match(http_res)
        #new_website.headers = http_res.headers

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
