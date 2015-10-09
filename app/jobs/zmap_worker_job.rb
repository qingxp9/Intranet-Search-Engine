require 'open3'
class ZmapWorkerJob < ActiveJob::Base
  queue_as :default

  def perform( describe, ip, port, filename, task_id )
    scan_task = ScanTask.find(task_id)
    scan_task.update( status: "scan" )
    logs = []

    if describe == "outer"

      pathname = "#{ZMAP_LOG_PATH}/outer/#{filename}"
      command = "zmap -p #{port} -b plugins/zmap/blacklist.conf #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{pathname}"
      logs << command

      Open3.popen3(command) do |stdin, stdout, stderr, thread|
        num = 0
        while line=stderr.gets do
          num+=1
          logs << line
          scan_task.update( logs: logs) if num % 5 == 0
        end

        while line=stdout.gets do
          logs << line
        end
      end

      scan_task.update( status: "import" )
      Host.zmap_read( pathname, port)

    else #inner

      pathname = "#{ZMAP_LOG_PATH}/inner/#{filename}"
      command = "zmap -p #{port} #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{pathname}"
      logs << command

      Open3.popen3(command) do |stdin, stdout, stderr, thread|
        num = 0
        while line=stderr.gets do
          num+=1
          logs << line
          scan_task.update( logs: logs) if num % 5 == 0
        end

        while line=stdout.gets do
          logs << line
        end
      end

      scan_task.update( status: "import" )
      Intranet.zmap_read( pathname, port, describe)
    end


    scan_task.update( status: "finish", logs: logs )

  end
end
