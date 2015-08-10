namespace :scan do
  desc "run whatweb to scan web"
  task :whatweb_scan => :environment do
    `#{WHATWEB_PATH}/whatweb #{TARGET_RANGE} -p +#{WHATWEB_PLUGES} --log-json \"#{WHATWEB_LOG_PATH}/#{Time.now.strftime("%Y%m%d%H")}.log\"`
    Website.whatweb_read
  end

  desc "run zmap to scan host"
  task :zmap_scan => :environment do
    File.readlines("plugins/zmap/port_list").each do |port|
      `echo "11112222" | sudo -S zmap -i eth0 -p #{port} -w plugins/zmap/attack_url.txt -o - | zgrab --port #{port} --data=plugins/zmap/http-req > #{ZMAP_LOG_PATH}/#{Time.now.strftime("%Y%m%d%H")}-#{port}.log`
    end
    Host.zmap_read
  end
end
