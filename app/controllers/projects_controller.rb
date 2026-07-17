class ProjectsController < ApplicationController
  def index
    if current_user
      @projects = current_user.projects
    else
      redirect_to new_user_session_path
    end
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to @project, notice: "Проект создан!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @project = Project.find(params[:id])
    @tasks = @project.tasks
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to @project, notice: "Проект обновлён!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path, notice: "Проект удалён!"
  end

  private

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
