require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { User.create(email: "test@test.com", password: "password") }
  let(:project) { Project.create(title: "Проект", user: user) }

  # ===== ВАЛИДАЦИИ =====
  it "создаёт задачу с валидными данными" do
    task = Task.new(title: "Тест", status: "to_do", priority: "medium", project: project)
    expect(task).to be_valid
  end

  it "не создаёт задачу без названия" do
    task = Task.new(title: nil, status: "to_do", priority: "medium", project: project)
    expect(task).not_to be_valid
  end

  it "не создаёт задачу без проекта" do
    task = Task.new(title: "Тест", status: "to_do", priority: "medium")
    expect(task).not_to be_valid
  end

  # ===== ПЕРЕХОДЫ СТАТУСОВ =====
  it "to_do → in_progress разрешён" do
    task = Task.create(title: "Тест", status: "to_do", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("in_progress")).to be true
  end

  it "to_do → done запрещён" do
    task = Task.create(title: "Тест", status: "to_do", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("done")).to be false
  end

  it "in_progress → to_do разрешён" do
    task = Task.create(title: "Тест", status: "in_progress", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("to_do")).to be true
  end

  it "in_progress → in_testing разрешён" do
    task = Task.create(title: "Тест", status: "in_progress", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("in_testing")).to be true
  end

  it "in_progress → done запрещён" do
    task = Task.create(title: "Тест", status: "in_progress", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("done")).to be false
  end

  it "in_testing → done разрешён" do
    task = Task.create(title: "Тест", status: "in_testing", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("done")).to be true
  end

  it "in_testing → rejected разрешён" do
    task = Task.create(title: "Тест", status: "in_testing", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("rejected")).to be true
  end

  it "in_testing → to_do запрещён" do
    task = Task.create(title: "Тест", status: "in_testing", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("to_do")).to be false
  end

  it "done → никуда нельзя" do
    task = Task.create(title: "Тест", status: "done", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("in_progress")).to be false
    expect(service.can_transition_to?("rejected")).to be false
  end

  it "rejected → in_progress разрешён" do
    task = Task.create(title: "Тест", status: "rejected", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("in_progress")).to be true
  end

  it "rejected → done запрещён" do
    task = Task.create(title: "Тест", status: "rejected", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.can_transition_to?("done")).to be false
  end

  # ===== ПОДСКАЗКИ =====
  it "возвращает подсказку для статуса to_do" do
    task = Task.create(title: "Тест", status: "to_do", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.hint).to include("In progress")
  end

  it "возвращает 'Нет доступных переходов' для статуса done" do
    task = Task.create(title: "Тест", status: "done", priority: "medium", project: project)
    service = StatusTransitionService.new(task)
    expect(service.hint).to eq("Нет доступных переходов")
  end
end