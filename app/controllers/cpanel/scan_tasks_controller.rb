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

      respond_to do |format|
        if @scan_task.save
          format.html { redirect_to @scan_task, notice: 'Scan task was successfully created.' }
          format.json { render :show, status: :created, location: @scan_task }
        else
          format.html { render :new }
          format.json { render json: @scan_task.errors, status: :unprocessable_entity }
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
        format.html { redirect_to scan_tasks_url, notice: 'Scan task was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_scan_task
        @scan_task = ScanTask.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def scan_task_params
        params.require(:scan_task).permit(:tool, :targets, :ports, :describe)
      end
  end
end
