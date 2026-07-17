require "rails_helper"

RSpec.describe TasksController, type: :controller do
  let(:user) { User.create(email: "test@test.com", password: "password") }
  let(:project) { Project.create(title: "Проект", user: user) }
  let(:task) { Task.create(title: "Задача", status: "to_do", priority: "medium", project: project) }

  before { sign_in user }

  describe "GET #index" do
    it "возвращает список задач" do
      get :index, params: { project_id: project.id }
      expect(assigns(:tasks)).to eq(project.tasks)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "показывает форму создания" do
      get :new, params: { project_id: project.id }
      expect(assigns(:task)).to be_a_new(Task)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    it "создаёт задачу" do
      expect do
        post :create, params: { project_id: project.id, task: { title: "Новая задача", status: "to_do", priority: "medium" } }
      end.to change { Task.count }.by(1)
      expect(response).to redirect_to(project_tasks_path(project))
    end

    it "не создаёт задачу без названия" do
      expect do
        post :create, params: { project_id: project.id, task: { title: "", status: "to_do", priority: "medium" } }
      end.not_to(change { Task.count })
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET #show" do
    it "показывает задачу" do
      get :show, params: { project_id: project.id, id: task.id }
      expect(assigns(:task)).to eq(task)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #edit" do
    it "показывает форму редактирования" do
      get :edit, params: { project_id: project.id, id: task.id }
      expect(assigns(:task)).to eq(task)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update" do
    it "обновляет статус задачи" do
      patch :update, params: { project_id: project.id, id: task.id, task: { status: "in_progress" } }
      expect(task.reload.status).to eq("in_progress")
      expect(response).to redirect_to(project_tasks_path(project))
    end

    it "не обновляет статус на запрещённый" do
      patch :update, params: { project_id: project.id, id: task.id, task: { status: "done" } }
      expect(task.reload.status).to eq("to_do")
      expect(response).to redirect_to(project_tasks_path(project))
    end
  end

  describe "DELETE #destroy" do
    it "удаляет задачу" do
      delete :destroy, params: { project_id: project.id, id: task.id }
      expect(Task.count).to eq(0)
      expect(response).to redirect_to(project_tasks_path(project))
    end
  end
end
