json.count @records.count
json.set! :results do
  json.array!(@records) do |f|
    json.extract! f, :belong, :ip, :port, :server, :title
    json.check_time f.check_time.strftime("%F %T")
  end
end

