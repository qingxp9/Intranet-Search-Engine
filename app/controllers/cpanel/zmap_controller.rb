module Cpanel
  class ZmapController < ApplicationController
    def index
    end

    def scan
      target_name = params[:name]? params[:name] : "outer"
      target_ip   = params[:ip].sub(","," ")
      ports       = params[:port].split(",")

      ZmapWorkerJob.perform_later(
        target_name, target_ip, ports
      )

      render inline: "#{target_name} <br/> #{target_ip} <br/> #{ports}  "

    end
  end
end
