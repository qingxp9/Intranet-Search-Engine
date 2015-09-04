namespace :app_count do
  desc "count http_server"
  task :calculate => :environment do
    redis = Redis.new
    app=["nginx", "apache", "unknown"]

    app.each do |each|
      results=Website.search(
        query: {
          multi_match: {
            query: each,
            fields: 'http_server'
          }
        }
      ).records
      redis.set(each, results.count)
    end
  end
end
