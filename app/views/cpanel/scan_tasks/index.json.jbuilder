json.array!(@scan_tasks) do |scan_task|
  json.id scan_task.id.to_s
  json.extract! scan_task, :type, :targets, :ports, :describe, :updated_at, :output, :status
  json.url cpanel_scan_task_path(scan_task, format: :json)
end
