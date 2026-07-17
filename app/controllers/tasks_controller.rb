# typed: false

class TasksController < ApplicationController
  extend T::Sig

  before_action :set_project

  sig { void }
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

  sig { void }
  def new
    @task = @project.tasks.build
  end

  sig { void }
  def show
    @task = @project.tasks.find(params[:id])
  end

  sig { returns(T.untyped) }
  def create
    @task = @project.tasks.build(task_params)

    if @task.save
      redirect_to project_tasks_path(@project), notice: "Задача создана!"
    else
      render :new, status: :unprocessable_entity
    end
    @task
  end

  sig { void }
  def edit
    @task = @project.tasks.find(params[:id])
  end

  sig { returns(T.untyped) }
  def update
    @task = @project.tasks.find(params[:id])
    service = StatusTransitionService.new(@task)

    if params[:task][:status] && service.can_transition_to?(params[:task][:status])
      service.transition_to!(params[:task][:status])
      redirect_to project_tasks_path(@project), notice: "Статус обновлён!"
    elsif @task.update(task_params)
      redirect_to project_tasks_path(@project), notice: "Задача обновлена!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  sig { void }
  def destroy
    @task = @project.tasks.find(params[:id])
    @task.destroy
    redirect_to project_tasks_path(@project), notice: "Задача удалена!"
  end

  private

  sig { void }
  def set_project
    @project = Project.find(params[:project_id])
  end

  sig { returns(ActionController::Parameters) }
  def task_params
    params.require(:task).permit(:title, :description, :status, :priority)
  end
end