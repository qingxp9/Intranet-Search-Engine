if @scan_task.type == "zmap_port_scan"
  json.id @scan_task.id.to_s
  json.extract! @scan_task, :targets, :ports, :describe, :status
  json.updated_at @scan_task.updated_at.strftime("%F %T")
  json.logs @scan_task.logs
  json.count @scan_task.logs.count
end
