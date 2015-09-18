class ScanTask
  include Mongoid::Document
  field :tool, type: String
  field :targets, type: String
  field :ports, type: String
  field :describe, type: String
  field :time, type: Time
  field :output, type: String
  field :status, type: String
end
