require "rails_helper"

RSpec.describe "Tasks", type: :request do
  let(:user) { User.create(email: "test@test.com", password: "password") }
  let(:project) { Project.create(title: "Проект", user: user) }

  before { sign_in user }

  it "создаёт задачу" do
    post project_tasks_path(project), params: { task: { title: "Новая задача", status: "to_do", priority: "medium" } }
    expect(response).to redirect_to(project_tasks_path(project, locale: "ru"))
    expect(Task.last.title).to eq("Новая задача")
  end

  it "не создаёт задачу без названия" do
    post project_tasks_path(project), params: { task: { title: "", status: "to_do", priority: "medium" } }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it "обновляет статус задачи" do
    task = Task.create(title: "Задача", status: "to_do", priority: "medium", project: project)
    patch project_task_path(project, task), params: { task: { status: "in_progress" } }
    expect(task.reload.status).to eq("in_progress")
  end

  it "удаляет задачу" do
    task = Task.create(title: "Задача", status: "to_do", priority: "medium", project: project)
    delete project_task_path(project, task)
    expect(Task.count).to eq(0)
  end
end
