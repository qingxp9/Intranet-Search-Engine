json.array!(@scan_tasks) do |scan_task|
  json.extract! scan_task, :id, :targets, :ports, :describe, :time, :output, :status
  json.url scan_task_url(scan_task, format: :json)
end
