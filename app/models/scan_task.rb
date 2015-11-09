class ScanTask
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :targets, type: Array, default: []
  field :ports, type: Array, default: []
  field :describe, type: String
  field :output, type: Array, default: []
  field :status, type: String
  field :logs, type: Array, default: []

  validates :type, presence: true
  validates :targets, presence: true
  validates :ports, presence: true
  validate :validate_targets
  validate :validate_ports

  def targets_list
    self.targets.join ", "
  end

  def ports_list
    self.ports.join ", "
  end

  def to_csv
    CSV.generate do |csv|
      self.logs.map{|t| t["ip"]}.each do |item|
        csv << item.split
      end
    end
  end

  def validate_targets
    targets.each do |ip|
      unless ip.match(/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(\/\d{1,5})?$/)
        errors.add(:targets, "#{ip} is not a valid ip")
      end
    end
  end

  def validate_ports
    ports.each do |port|
      unless port.match(/^\d{1,5}$/)
        errors.add(:ports, "#{port} is not a valid port")
      end
    end
  end
end
