class IntranetsController < ApplicationController

  def index
    @intranets = Intranet.page(params[:page]).per(10)
  end

  def search
    @intranets = Intranet.search(params[:q]).records.page(params[:page]).per(30)
    render 'index'
  end

end
