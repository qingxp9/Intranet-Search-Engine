module Cpanel
  class ZmapController < ApplicationController
    def index
    end

    def scan
      @scan_task = ScanTask.new
      desc = params[:desc]? params[:desc] : "outer"
      target_ip   = params[:ip].sub(","," ")
      ports       = params[:port].split(/[,| ]/)


      ports.each do |port|
        filename = "#{Time.now.strftime('%Y%m%d')}-#{target_name}-#{rand(10000...100000)}-#{port}.log"

        ZmapWorkerJob.perform_async(
          desc, target_ip, port, filename
        )
      end


      render inline: "#{target_name} <br/> #{target_ip} <br/> #{ports}  "

    end
  end
end
