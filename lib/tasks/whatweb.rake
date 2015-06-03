namespace :whatweb do
  desc "run whatweb to scan web"
  task :scan => :environment do
    `#{WHATWEB_PATH}/whatweb #{TARGET_RANGE} -p +#{WHATWEB_PLUGES} --log-json \"#{WHATWEB_SAVE_PATH}/#{Time.now.strftime("%Y%m%d")}.log\"`
    Website.whatweb_read
  end
end
