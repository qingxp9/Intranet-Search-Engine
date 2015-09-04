class WebsitesController < ApplicationController

  # GET /websites
  # GET /websites.json
  def index
    @websites = Website.page(params[:page]).per(10)
    begin_time = Time.now
    @waste_time = Time.now - begin_time
  end

  def search
    begin_time = Time.now
    @websites = Website.search(
      size: 500,
      query: {
        multi_match: {
          query: params[:q].to_s,
          fields: ['server', 'title', 'keywords', 'os', 'ip', 'target', 'description'],
          fuzziness: 2
        }
      }
    ).records.page(params[:page]).per(30)
    @waste_time = Time.now - begin_time

    render 'index'

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def website_params
      params.require(:website).permit(:target, :port, :webapp, :server, :os, :headers, :title, :keywords, :description, :body )
    end
end
