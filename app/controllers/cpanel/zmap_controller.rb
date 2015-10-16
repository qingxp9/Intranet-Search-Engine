module Cpanel
  class ZmapController < ApplicationController
    def index
      @scan_tasks = ScanTask.order_by(created_at: 'desc')
    end
  end
end
