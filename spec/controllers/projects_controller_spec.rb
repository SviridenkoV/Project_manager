require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { User.create(email: "test@test.com", password: "password") }
  let(:project) { Project.create(title: "Проект", user: user) }

  before { sign_in user }

  describe "GET #index" do
    it "возвращает список проектов" do
      get :index
      expect(assigns(:projects)).to eq([project])
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "показывает форму создания" do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    it "создаёт проект" do
      expect {
        post :create, params: { project: { title: "Новый проект", description: "Описание" } }
      }.to change { Project.count }.by(1)
      expect(response).to redirect_to(project_path(Project.last))
    end

    it "не создаёт проект без названия" do
      expect {
        post :create, params: { project: { title: "", description: "Описание" } }
      }.not_to change { Project.count }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET #show" do
    it "показывает проект" do
      get :show, params: { id: project.id }
      expect(assigns(:project)).to eq(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #edit" do
    it "показывает форму редактирования" do
      get :edit, params: { id: project.id }
      expect(assigns(:project)).to eq(project)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH #update" do
    it "обновляет проект" do
      patch :update, params: { id: project.id, project: { title: "Новое название" } }
      expect(project.reload.title).to eq("Новое название")
      expect(response).to redirect_to(project_path(project))
    end

    it "не обновляет проект без названия" do
      patch :update, params: { id: project.id, project: { title: "" } }
      expect(project.reload.title).to eq("Проект")
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    it "удаляет проект" do
      delete :destroy, params: { id: project.id }
      expect(Project.count).to eq(0)
      expect(response).to redirect_to(projects_path)
    end
  end
end