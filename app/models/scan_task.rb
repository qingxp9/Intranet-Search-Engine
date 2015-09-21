class ScanTask
  include Mongoid::Document
  include Mongoid::Timestamps

  field :tool, type: String
  field :targets, type: Array, default: []
  field :ports, type: Array, default: []
  field :describe, type: String
  field :output, type: Array, default: []
  field :status, type: String

  def targets_list=(arg)
    self.targets = arg.split(/[,| ]/)
  end

  def targets_list
    self.targets.join ", "
  end

  def ports_list=(arg)
    self.ports = arg.split(/[,| ]/)
  end

  def ports_list
    self.ports.join ", "
  end
end
