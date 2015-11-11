require 'open3'
class ZmapWorkerJob < ActiveJob::Base
  queue_as :default

  def perform(task_id)
    task = ScanTask.find(task_id)

    ##different scan task
    task.update( status: "scan" )
    begin_time = Time.now
    case task.type
    when "zmap_port_scan"
      zmap_port_scan(task)
    when "zmap_port_scan_import"
      zmap_port_scan_import(task)
    else
      task.update( status: "type error")
      return
    end

    task.update( status: "finish", scan_cost: (Time.now - begin_time))
  end

  def zmap_port_scan_import(task)
    logs = []
    task.ports.each do |port|
      task.describe = "outer" if task.describe == ""
      filename = "#{Time.now.strftime('%Y%m%d')}-#{task.describe}-#{port}-#{rand(1000...10000)}.log"
      task.output << filename
      task.save

      if task.describe == "outer"

        pathname = "#{ZMAP_LOG_PATH}/banner/outer/#{filename}"
        command = "zmap -p #{port} -b plugins/zmap/blacklist.conf #{task.targets.join(" ")} | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{pathname}"
        logs << command

        Open3.popen3(command) do |stdin, stdout, stderr, thread|
          num = 0
          while line=stderr.gets do
            num+=1
            logs << line
            task.update( logs: logs) if num % 5 == 0
          end

          while line=stdout.gets do
            logs << line
          end
        end

        task.update( status: "host import", logs: logs )
        Host.zmap_read( pathname, port)

      else #inner

        pathname = "#{ZMAP_LOG_PATH}/banner/inner/#{filename}"
        command = "zmap -p #{port} #{task.targets.join(" ")} | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{pathname}"
        logs << command

        Open3.popen3(command) do |stdin, stdout, stderr, thread|
          num = 0
          while line=stderr.gets do
            num+=1
            logs << line
            task.update( logs: logs) if num % 5 == 0
          end

          while line=stdout.gets do
            logs << line
          end
        end

        task.update( status: "intranet import", logs: logs )
        Intranet.zmap_read( pathname, port, task.describe)
      end
    end
  end

  def zmap_port_scan(task)
    logs = []
    task.ports.each do |port|
      command = "zmap -p #{port} #{task.targets.join(" ")}| zgrab --port #{port} --data=plugins/zmap/http-req"

      Open3.popen3(command) do |stdin, stdout, stderr, thread|
        while line=stdout.gets do
          begin
            hash=JSON.parse(line)
          rescue
            next
          end

          next if !hash["error"].nil?
          next if hash["ip"].nil?

          title  = hash["data"]["read"].match(/<title>(.*?)<\/title>/)
          title  = title.nil? ? nil : title[1]
          server = hash["data"]["read"].match(/Server:(.*?)\r\n/)
          server = server.nil? ? nil : server[1]

          logs << {"ip":hash["ip"],"title":title,"server":server}
        end
      end

      task.update( logs: logs )
    end
  end

end
