module Cpanel
  class ScanTasksController < ApplicationController
    before_action :set_scan_task, only: [:show, :edit, :update, :destroy]

    # GET /scan_tasks
    # GET /scan_tasks.json
    def index
      @scan_tasks = ScanTask.all
    end

    # GET /scan_tasks/1
    # GET /scan_tasks/1.json
    def show
    end

    # GET /scan_tasks/new
    def new
      @scan_task = ScanTask.new
    end

    # GET /scan_tasks/1/edit
    def edit
    end

    # POST /scan_tasks
    # POST /scan_tasks.json
    def create
      @scan_task = ScanTask.new(scan_task_params)
      @scan_task.status = "new"

      respond_to do |format|
        if @scan_task.save
          zmap_scan(@scan_task) if @scan_task.tool == "zmap"
        else
          format.html { render :new }
        end
      end
    end

    # PATCH/PUT /scan_tasks/1
    # PATCH/PUT /scan_tasks/1.json
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

    # DELETE /scan_tasks/1
    # DELETE /scan_tasks/1.json
    def destroy
      @scan_task.destroy
      respond_to do |format|
        format.html { redirect_to cpanel_scan_tasks_url, notice: 'Scan task was successfully destroyed.' }
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
          ZmapWorkerJob.perform_later(
            task.describe, task.targets.join(" "), port, filename
          )
          task.output << filename
        end
        task.status = "finished"
        task.save
      end
  end
end
