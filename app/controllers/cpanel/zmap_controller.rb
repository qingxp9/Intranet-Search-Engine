module Cpanel
  class ZmapController < ApplicationController
    def index
    end

    def scan
      target_name = params[:name]? params[:name] : "outer"
      target_ip   = params[:ip].split(",")
      ports       = params[:port].split(",")
      #ZmapWorkerJob.perform_later(
        #target_name, target_ip, ports
      #)
      #target_ip = ["10.18.25.0/24"]
      #ports = [ 22,80 ]


      #ZmapWorkerJob.perform_now(
        #target_name, target_ip, ports
      #)
      render inline: "#{target_name} <br/> #{target_ip} <br/> #{ports}  "

    end
  end
end
