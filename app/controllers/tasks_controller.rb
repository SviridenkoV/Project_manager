class TasksController < ApplicationController
  before_action :set_project

  def index
    @tasks = @project.tasks
  end

  def new
    @task = @project.tasks.build   # ← здесь одна задача, не массив
  end

  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      redirect_to project_tasks_path(@project), notice: "Задача создана!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  @task = @project.tasks.find(params[:id])
end

  def update
    @task = @project.tasks.find(params[:id])

    if @task.update(task_params)
      redirect_to project_tasks_path(@project), notice: "Задача обновлена!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = @project.tasks.find(params[:id])
    @task.destroy

    redirect_to project_tasks_path(@project), notice: "Задача удалена!"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end

  
end