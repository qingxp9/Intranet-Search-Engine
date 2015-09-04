namespace :scan do
  desc "run whatweb to scan web"
  task :whatweb_scan => :environment do
    `#{WHATWEB_PATH}/whatweb #{TARGET_RANGE} -p +#{WHATWEB_PLUGES} --log-json \"#{WHATWEB_LOG_PATH}/#{Time.now.strftime("%Y%m%d")}.log\"`
    Website.whatweb_read
  end

  desc "run zmap to scan host"
  task :zmap_scan => :environment do
    Host.zmap_read
  end
end
