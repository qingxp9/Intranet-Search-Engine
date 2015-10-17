require 'open3'
class ZmapWorkerJob < ActiveJob::Base
  queue_as :default

  def perform(task_id)
    task = ScanTask.find(task_id)
    ##different scan task
    task.update( status: "scan" )
    zmap_host_scan(task) if task.type == "zmap_host_scan"
    zmap_banner_scan(task) if task.type == "zmap_banner_scan"
    ##deal finish
    task.update( status: "finish")
  end

  def zmap_banner_scan(task)
    logs = []
    task.ports.each do |port|
      task.describe = "outer" if task.describe == ""
      filename = "#{Time.now.strftime('%Y%m%d')}-#{task.describe}-#{port}-#{rand(1000...10000)}.log"
      task.output << filename
      task.save

      if task.describe == "outer"

        pathname = "#{ZMAP_LOG_PATH}/banner/outer/#{filename}"
        command = "zmap -p #{port} -b plugins/zmap/blacklist.conf #{task.targets.join(" ")} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{pathname}"
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
        command = "zmap -p #{port} #{task.targets.join(" ")} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{pathname}"
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

  def zmap_host_scan(task)
    logs = []
    task.ports.each do |port|
      filename = "#{Time.now.strftime('%Y%m%d')}-#{port}-#{rand(1000...10000)}.log"
      task.output << filename
      task.save

      pathname = "#{ZMAP_LOG_PATH}/host/#{filename}"
      command = "zmap -p #{port}  #{task.targets.join(" ")} -o #{pathname}"
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

      task.update( logs: logs )
    end
  end

end
