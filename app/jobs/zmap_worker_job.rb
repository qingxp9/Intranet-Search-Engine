require 'open3'
class ZmapWorkerJob < ActiveJob::Base
  queue_as :default

  def perform( describe, ip, port, filename, task_id )
    scan_task = ScanTask.find(task_id)
    scan_task.update( status: "scan" )

    if describe == "outer"

      filepath = "#{ZMAP_LOG_PATH}/outer/#{filename}"

      Open3.popen3("zmap -p #{port} -b plugins/zmap/blacklist.conf #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{filepath}") do |stdin, stdout, stderr, thread|
        str = []
        num = 0
        while line=stderr.gets do
          num+=1
          str << line
          scan_task.update( logs: str) if num % 3 == 0
        end
          scan_task.update( logs: str)
      end

      scan_task.update( status: "import" )
      Host.zmap_read( filepath, port)

    else #inner

      filepath = "#{ZMAP_LOG_PATH}/inner/#{filename}"

      Open3.popen3("zmap -p #{port} #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{filepath}") do |stdin, stdout, stderr, thread|
        str = []
        num = 0
        while line=stderr.gets do
          num+=1
          str << line
          scan_task.update( logs: str) if num % 3 == 0
        end
          scan_task.update( logs: str)
      end

      scan_task.update( status: "import" )
      Intranet.zmap_read( filepath, port, describe)
    end


    scan_task.update( status: "finish" )

  end
end
