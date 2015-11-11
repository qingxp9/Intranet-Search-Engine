json.array!(@scan_tasks) do |scan_task|
  json.id scan_task.id.to_s
  json.extract! scan_task, :type, :targets, :ports, :describe, :output, :status
  json.updated_at scan_task.updated_at.strftime("%F %T")
  json.url cpanel_scan_task_path(scan_task, format: :json)
  json.count scan_task.logs.count
end
