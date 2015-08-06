class Host
  include Mongoid::Document
  field :ip, type: String
  field :port, type: String
  field :check_time, type: DateTime
  field :server, type: String
  field :banner, type: String
  field :title, type: String

  def self.zmap_read
  end
end
