module Cpanel
  class ScanTasksController < ApplicationController
    before_action :set_scan_task, only: [:show, :edit, :update, :destroy]
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!, only: [:show, :create, :destroy, :index]

    def index
      @scan_tasks = ScanTask.order_by(created_at: 'desc')
    end

    def show
      respond_to do |format|
        format.html
        format.json
        format.csv { send_data @scan_task.to_csv }
      end
    end

    def new
      @scan_task = ScanTask.new
    end

    def create
      @scan_task = ScanTask.new(scan_task_params)
      @scan_task.status = "new"
      @scan_task.targets = params.require(:scan_task)[:targets].split(/[,| ]/)
      @scan_task.ports = params.require(:scan_task)[:ports].split(/[,| ]/)

      respond_to do |format|
        if @scan_task.save
          zmap_worker(@scan_task) if @scan_task.type.include?("zmap")

          format.html { redirect_to [:cpanel,@scan_task] }
          format.json { render json:  {"path": cpanel_scan_task_path(@scan_task, format: :json), "id": @scan_task.id.to_s} }
        else
          format.html { render :new }
          format.json { render json: { errors: @scan_task.errors } }
        end
      end
    end

    def destroy
      @scan_task.destroy
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Scan task was successfully destroyed.' }
        format.json { render json: { status: 1 } }
      end
    end

    private
      def set_scan_task
        @scan_task = ScanTask.find(params[:id])
      end

      def scan_task_params
        params.require(:scan_task).permit(:type,  :describe)
      end

      def zmap_worker(task)
          ZmapWorkerJob.perform_later(task.id.to_s)
      end
  end
end
