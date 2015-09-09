namespace :scan do
  desc "run zmap to scan host"
  task :zmap_scan => :environment do
    Host.zmap_read
  end
end
