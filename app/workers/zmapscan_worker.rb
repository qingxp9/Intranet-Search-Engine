class ZmapscanWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"

  def zmapscan( target_ip, *ports, mode)
    puts target_ip
    puts ports
  end
end
