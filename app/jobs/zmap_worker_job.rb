class ZmapWorkerJob < ActiveJob::Base
  queue_as :default

  def perform( describe, ip, port, filename )
      if describe == "outer"
        filepath = "#{ZMAP_LOG_PATH}/outer/#{filename}"

        `zmap -p #{port} -b plugins/zmap/blacklist.conf #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{filepath}`

      else #inner

        filepath = "#{ZMAP_LOG_PATH}/inner/#{filename}"

        `zmap -p #{port} #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{filepath}`
      end
      Host.zmap_read( filepath, port)

  end
end
