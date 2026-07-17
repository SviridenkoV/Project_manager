# typed: strict
require 'active_record/relation'

class ProjectsController < ApplicationController
  extend T::Sig

  sig { void }
  def index
    if current_user
      @projects = T.let(current_user.projects, ActiveRecord::Relation)
    else
      redirect_to new_user_session_path
    end
  end

  sig { void }
  def new
    @project = T.let(Project.new, Project)
  end

  sig { returns(Project) }
  def create
    @project = T.let(current_user.projects.build(project_params), Project)

    if @project.save
      redirect_to @project, notice: "Проект создан!"
    else
      render :new, status: :unprocessable_entity
    end
    @project
  end

  sig { void }
  def show
    @project = T.let(Project.find(params[:id]), Project)
    @tasks = T.let(@project.tasks, ActiveRecord::Relation)
  end

  sig { void }
  def edit
    @project = T.let(Project.find(params[:id]), Project)
  end

  sig { returns(Project) }
  def update
    @project = T.let(Project.find(params[:id]), Project)

    if @project.update(project_params)
      redirect_to @project, notice: "Проект обновлён!"
    else
      render :edit, status: :unprocessable_entity
    end
    @project
  end

  sig { void }
  def destroy
    @project = T.let(Project.find(params[:id]), Project)
    @project.destroy
    redirect_to projects_path, notice: "Проект удалён!"
  end

  private

  sig { returns(ActionController::Parameters) }
  def project_params
    params.require(:project).permit(:title, :description)
  end
end