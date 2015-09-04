# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
set :environment, :development
every 1.days, :at => '0:00 am' do
  rake "scan:whatweb_scan"
  command "
  cat 'plugins/zmap/port_list' | while read port
  do
    echo '11112222' |sudo -S zmap -i eth0 -p $port -w plugins/zmap/attack_url.txt -o - | zgrab --port $port --data=plugins/zmap/http-req > 'log/zmap_logs/`date +%Y%m%d`-$port.log'
  done
    RAILS_ENV=development bundle exec rake scan:zmap_scan --silent
  "
end

#every :hour do
#  rake "app_count:calculate"
#end
