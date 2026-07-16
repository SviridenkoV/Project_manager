require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  let(:user) { User.create(email: "test@test.com", password: "password") }
  let(:project) { Project.create(title: "Проект", user: user) }

  before do
    allow(view).to receive(:user_signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(user)
    assign(:project, project)
    assign(:tasks_by_status, {})
  end

  it "показывает ссылку на создание задачи" do
    render
    expect(rendered).to match(/Новая задача/)
  end

  it "показывает задачи по статусам" do
    task1 = Task.create(title: "Задача 1", status: "to_do", project: project, priority: "medium")
    assign(:tasks_by_status, { "to_do" => [task1] })
    render
    expect(rendered).to match(/Задача 1/)
  end
end