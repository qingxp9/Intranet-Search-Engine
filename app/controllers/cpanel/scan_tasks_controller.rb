module Cpanel
  class ScanTasksController < ApplicationController
    before_action :set_scan_task, only: [:show, :edit, :update, :destroy]

    def index
      @scan_tasks = ScanTask.all
    end
    def show
    end
    def new
      @scan_task = ScanTask.new
    end
    def edit
    end

    def create
      @scan_task = ScanTask.new(scan_task_params)
      @scan_task.status = "new"
      @scan_task.describe = "outer" if @scan_task.describe == ""

      respond_to do |format|
        if @scan_task.save
          zmap_scan(@scan_task) if @scan_task.tool == "zmap"
          format.html { redirect_to [:cpanel,@scan_task] }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @scan_task.update(scan_task_params)
          format.html { redirect_to @scan_task, notice: 'Scan task was successfully updated.' }
          format.json { render :show, status: :ok, location: @scan_task }
        else
          format.html { render :edit }
          format.json { render json: @scan_task.errors, status: :unprocessable_entity }
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
        params.require(:scan_task).permit(:tool, :targets_list, :ports_list, :describe)
      end

      def zmap_scan(task)
        task.ports.each do |port|
          filename = "#{Time.now.strftime('%Y%m%d')}-#{task.describe}-#{rand(10000...100000)}-#{port}.log"
          task.output << filename
          task.save
          ZmapWorkerJob.perform_later(
            task.describe, task.targets.join(" "), port, filename, task.id.to_s
          )
        end
      end
  end
end
