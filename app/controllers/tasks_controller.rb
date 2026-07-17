class TasksController < ApplicationController
  before_action :set_project

  def index
    @tasks = @project.tasks.order(
      Arel.sql("CASE priority
        WHEN 'critical' THEN 0
        WHEN 'high' THEN 1
        WHEN 'medium' THEN 2
        WHEN 'low' THEN 3
      END")
    )
    @tasks_by_status = @tasks.group_by(&:status)
  end

  def new
    @task = @project.tasks.build
  end

  def show
    @task = @project.tasks.find(params[:id])
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
    service = StatusTransitionService.new(@task)

    if params[:task][:status] && service.can_transition_to?(params[:task][:status])
      service.transition_to!(params[:task][:status])
      redirect_to project_tasks_path(@project), notice: "Статус обновлён!"
    else
      redirect_to project_tasks_path(@project), alert: "Нельзя перейти в этот статус"
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
    params.require(:task).permit(:title, :description, :status, :priority)
  end
end
