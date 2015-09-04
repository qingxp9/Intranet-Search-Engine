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

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def host_params
      params.require(:host).permit(:ip, :port, :server, :banner, :title )
    end

    def self.search(query)
      __elasticsearch__.search(
        {
          size: 50,
          query: {
            multi_match: {
              query: query,
              fields: ['server', 'title', 'ip', 'banner']
            }
          }
        }
      )
    end
end
