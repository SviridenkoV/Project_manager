require 'rails_helper'

RSpec.describe "Projects", type: :system do
  let(:user) { User.create(email: "test@test.com", password: "password") }

  before do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Войти"   # ← изменил
  end

  it "создаёт новый проект" do
    visit new_project_path
    fill_in "project_title", with: "Мой проект"
    fill_in "project_description", with: "Описание проекта"
    click_button "Создать проект"

    expect(page).to have_content("Мой проект")
    expect(page).to have_content("Проект создан!")
  end

  it "показывает список проектов" do
    Project.create(title: "Проект 1", user: user)
    Project.create(title: "Проект 2", user: user)

    visit projects_path

    expect(page).to have_content("Проект 1")
    expect(page).to have_content("Проект 2")
  end

  it "удаляет проект" do
    project = Project.create(title: "Удаляемый проект", user: user)

    visit project_path(project)
    click_button "Удалить"

    expect(page).to have_content("Проект удалён!")
    expect(page).not_to have_content("Удаляемый проект")
  end
end