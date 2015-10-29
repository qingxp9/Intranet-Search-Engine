class IntranetsController < ApplicationController

  def index
    @intranets = Intranet.page(params[:page]).per(10)
  end

  def search
    begin_time = Time.now
    @keywords = params[:q].split.delete_if {|a|  a.count(":") != 0 }
    @intranets = Intranet.search(params[:q]).records.page(params[:page]).per(30)
  end

end
