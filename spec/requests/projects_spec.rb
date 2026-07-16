require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { User.create(email: "test@test.com", password: "password") }

  before { sign_in user }

  it "создаёт проект" do
    post projects_path, params: { project: { title: "Новый проект", description: "Описание" } }
    expect(response).to redirect_to(project_path(Project.last, locale: "ru"))
    expect(Project.last.title).to eq("Новый проект")
  end

  it "не создаёт проект без названия" do
    post projects_path, params: { project: { title: "", description: "Описание" } }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "обновляет проект" do
    project = Project.create(title: "Старый проект", user: user)
    patch project_path(project), params: { project: { title: "Новый заголовок" } }
    expect(project.reload.title).to eq("Новый заголовок")
  end

  it "удаляет проект" do
    project = Project.create(title: "Проект", user: user)
    delete project_path(project)
    expect(Project.count).to eq(0)
  end
end