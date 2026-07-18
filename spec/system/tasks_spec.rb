require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { User.create(email: "test@test.com", password: "password") }
  let(:project) { Project.create(title: "Проект", user: user) }

  before do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Войти"   # ← изменил
  end

  it "создаёт новую задачу" do
    visit project_tasks_path(project)
    click_link "Новая задача"

    fill_in "task_title", with: "Моя задача"
    fill_in "task_description", with: "Описание задачи"
    select "К выполнению", from: "task_status"
    select "Средний", from: "task_priority"
    click_button "Создать задачу"

    expect(page).to have_content("Моя задача")
    expect(page).to have_content("Задача создана!")
  end

  it "удаляет задачу через просмотр" do
    task = Task.create(title: "Удаляемая задача", status: "to_do", priority: "medium", project: project)

    visit project_task_path(project, task)
    click_button "Удалить"

    expect(page).to have_content("Задача удалена!")
    expect(page).not_to have_content("Удаляемая задача")
  end

  it "меняет статус задачи через редактирование" do
    task = Task.create(title: "Задача для статуса", status: "to_do", priority: "medium", project: project)

    visit project_task_path(project, task)
    click_link "Редактировать"

    select "В работе", from: "task_status"
    click_button "Обновить задачу"

    expect(page).to have_content("Статус обновлён!")
    expect(page).to have_content("В работе")
  end
end