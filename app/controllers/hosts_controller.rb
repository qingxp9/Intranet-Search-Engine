class HostsController < ApplicationController

  # GET /websites
  # GET /websites.json
  def index
    @hosts = Host.page(params[:page]).per(10)
    begin_time = Time.now
    @waste_time = Time.now - begin_time
  end

  def search
    begin_time = Time.now
    @hosts = Host.search(params[:q]).records.page(params[:page]).per(30)
    @waste_time = Time.now - begin_time
    render 'index'
  end

  def yyf
    target_name = "outer"
    target_ip = ["10.0.0.1/24"]
    ports = [ 22,80 ]
    ZmapWorkerJob.perform_later(
      target_name, target_ip, ports
    )
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def host_params
      params.require(:host).permit(:ip, :port, :server, :banner, :title )
    end

end
