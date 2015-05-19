class Website
  include Mongoid::Document
  field :target, type: String
  field :port, type: String
  field :webapp, type: String
  field :http_server, type: String
  field :os, type: String
  field :headers, type: String
  field :title, type: String
  field :keywords, type: String
  field :description, type: String
  field :body, type: String
  field :check_time, type: DateTime
end
