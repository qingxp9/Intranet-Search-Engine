module Cpanel
  class ScanTasksController < ApplicationController
    delegate :url_helpers, to: 'Rails.application.routes'
    before_action :set_scan_task, only: [:show, :edit, :update, :destroy]
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!, only: [:show, :create]

    def index
      @scan_tasks = ScanTask.order_by(created_at: 'desc')
    end
    def show
    end
    def new
      @scan_task = ScanTask.new
    end

    def create
      @scan_task = ScanTask.new(scan_task_params)
      @scan_task.status = "new"

      respond_to do |format|
        if @scan_task.save
          zmap_worker(@scan_task) if @scan_task.type.include?("zmap")

          format.html { redirect_to [:cpanel,@scan_task] }
          format.json { render json:  {"path": url_helpers.cpanel_scan_task_path(@scan_task, format: :json), "id": @scan_task.id.to_s} }
        else
          format.html { render :new }
        end
      end
    end

    def destroy
      @scan_task.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Scan task was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      def set_scan_task
        @scan_task = ScanTask.find(params[:id])
      end

      def scan_task_params
        params.require(:scan_task).permit(:type, :targets_list, :ports_list, :describe)
      end

      def zmap_worker(task)
          ZmapWorkerJob.perform_later(task.id.to_s)
      end
  end
end
