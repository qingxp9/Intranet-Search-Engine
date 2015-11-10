class IntranetsController < ApplicationController

  def index
  end

  def search
    begin_time = Time.now

    #use for js highlight
    @keywords = params[:q].split.delete_if {|a|  a.count(":") != 0 }
    @page = params[:page]

    @records=Intranet.search(params[:q]).records
    @intranets = @records.page(@page).per(30)

    respond_to do |format|
        format.html
        format.json
    end
  end

end
