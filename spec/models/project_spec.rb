require "rails_helper"

RSpec.describe Project, type: :model do
  let(:user) { User.create(email: "test@test.com", password: "password") }

  it "создаёт проект с валидными данными" do
    project = Project.new(title: "Тестовый проект", description: "Описание", user: user)
    expect(project).to be_valid
  end

  it "не создаёт проект без названия" do
    project = Project.new(title: nil, description: "Описание", user: user)
    expect(project).not_to be_valid
  end

  it "принадлежит пользователю" do
    project = Project.create(title: "Тест", user: user)
    expect(project.user).to eq(user)
  end

  it "удаляет задачи при удалении проекта" do
    project = Project.create(title: "Тест", user: user)
    Task.create(title: "Задача", status: "to_do", project: project)
    expect { project.destroy }.to change { Task.count }.by(-1)
  end
end
