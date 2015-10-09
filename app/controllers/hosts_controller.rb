class HostsController < ApplicationController

  def index
    @hosts = Host.page(params[:page]).per(10)
    begin_time = Time.now
    @waste_time = Time.now - begin_time
  end

  def search
    begin_time = Time.now
    @keywords = params[:q].split.delete_if {|a|  a.count(":") != 0 }
    @hosts = Host.search(params[:q]).records.page(params[:page]).per(30)
    @waste_time = Time.now - begin_time
    render 'index'
  end

end
