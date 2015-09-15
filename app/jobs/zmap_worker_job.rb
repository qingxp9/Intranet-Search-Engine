class ZmapWorkerJob < ActiveJob::Base
  queue_as :default

  def perform( target_name, target_ip, ports )
    if target_name == "outer"
      target_ip.each do |ip|
        puts target_ip
        ports.each do |port|
          puts port

          filename = "#{Time.now.strftime("%Y%m%d")}-outer#{rand(10000...100000)}-#{port}.log"
          puts filename
          puts "`sudo zmap -p #{port} #{ip} -o - | zgrab --port #{port} --data=plugins/zmap/http-req --output-file=#{ZMAP_LOG_PATH}/#{filename}`"
        end
      end

    else
          filename = "#{Time.now.strftime('%Y%m%d')}-#{target_name}#{rand(10000...100000)}-#{port}.log"

    end
  end
end
