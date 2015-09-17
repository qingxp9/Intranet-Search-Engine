class ZmapWorkerJob < ActiveJob::Base
  queue_as :default

  def perform( name, ip, ports )
    #puts ip

    ports.each do |port|
          filename = "#{Time.now.strftime('%Y%m%d')}-#{name}-#{rand(10000...100000)}-#{port}.log"
          #puts port
          if name == "outer"
              `zmap -p #{port} -b plugins/zmap/blacklist.conf #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{ZMAP_LOG_PATH}/outer/#{filename}`
          else
              `zmap -p #{port} #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{ZMAP_LOG_PATH}/inner/#{filename}`
          end
    end
  end
end
