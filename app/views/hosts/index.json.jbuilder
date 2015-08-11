json.array!(@websites) do |website|
  json.extract! website, :id, :target, :port, :webapp, :server, :os, :headers, :title, :keywords, :description, :body, :check_time
  json.url website_url(website, format: :json)
end
