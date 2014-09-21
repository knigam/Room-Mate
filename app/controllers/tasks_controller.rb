class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @task.group = current_user.groups.find(params[:group])
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task.group = current_user.groups.find(params[:task][:group_id])
    user_index = rand(@task.group.users.count)
    #for i in 0...@task.num_users
    (0... @task.num_users).each do |i|
      if user_index >= @task.group.users.count
        user_index = 0
      end
      @task.users << @task.group.users[user_index]
      user_index += 1
    end
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /tasks/complete
  # POST /items/complete.json
  def complete
    @task = Task.find(params[:id])
    last_user = @task.group.users.index(@task.users.last)
    
    @task.users.each do |u|
      last_user += 1
      if last_user >= @task.group.users.count
        last_user = 0
      end
      @task.users.delete(u)
      @task.users << @task.group.users[last_user]
    end
    
    @task.users.each do |u|
      u.notify(@task)      
    end

    respond_to do |format|
      if @task.save 
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { render action: 'new' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to @task.group }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :due, :priority, :num_users)
    end
end
