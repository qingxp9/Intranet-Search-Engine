class WhatwebWorkerJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    puts 'background whatweb job start '
    `whatweb www.baidu.com -p +/home/qingxp9/Developer/github/WhatWeb/my-plugins --log-json test.test`
    puts 'job end'
  end
end
