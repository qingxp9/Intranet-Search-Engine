class Website
  include Mongoid::Document
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  field :target, type: String
  field :port, type: String
  field :webapp, type: String
  field :http_server, type: String
  field :os, type: String
  field :headers, type: String
  field :title, type: String
  field :keywords, type: Array
  field :description, type: String
  field :ip, type: String
  field :check_time, type: DateTime

    def as_indexed_json(options={})
      as_json(except: [:target, :_id])
    end
end
