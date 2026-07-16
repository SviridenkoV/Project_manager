require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let(:user) { User.create(email: "test@test.com", password: "password") }
  let(:project) { Project.create(title: "Проект", user: user) }

  before do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"
  end

  it "создаёт новую задачу" do
    visit project_tasks_path(project)
    click_link "Новая задача"

    fill_in "task_title", with: "Моя задача"
    fill_in "task_description", with: "Описание задачи"
    select "To do", from: "task_status"
    select "Medium", from: "task_priority"
    click_button "Создать задачу"

    expect(page).to have_content("Моя задача")
    expect(page).to have_content("Задача создана!")
  end

  it "изменяет статус задачи" do
    task = Task.create(title: "Задача", status: "to_do", priority: "medium", project: project)

    visit project_tasks_path(project)
    select "In progress", from: "task_status"
    click_button "Изменить статус"

    expect(page).to have_content("Статус обновлён!")
  end

  it "удаляет задачу" do
    task = Task.create(title: "Удаляемая задача", status: "to_do", priority: "medium", project: project)

    visit project_tasks_path(project)
    click_button "Удалить"

    expect(page).to have_content("Задача удалена!")
    expect(page).not_to have_content("Удаляемая задача")
  end
end