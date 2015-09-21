module Cpanel
  class ZmapController < ApplicationController
    def index
      @scan_tasks = ScanTask.all
    end
  end
end
