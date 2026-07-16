require 'rails_helper'

RSpec.describe StatusTransitionService do
  let(:user) { User.create(email: "test@test.com", password: "password") }
  let(:project) { Project.create(title: "Проект", user: user) }
  let(:task) { Task.create(title: "Задача", status: "to_do", project: project) }
  let(:service) { described_class.new(task) }

  it "проверяет разрешённые переходы" do
    expect(service.can_transition_to?("in_progress")).to be true
    expect(service.can_transition_to?("done")).to be false
  end

  it "возвращает доступные статусы" do
    expect(service.available_statuses).to include("to_do", "in_progress")
  end

  it "меняет статус" do
    service.transition_to!("in_progress")
    expect(task.reload.status).to eq("in_progress")
  end

  it "выбрасывает ошибку при недопустимом переходе" do
    expect { service.transition_to!("done") }.to raise_error(ArgumentError)
  end
end