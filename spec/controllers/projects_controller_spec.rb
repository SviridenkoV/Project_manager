require "rails_helper"

RSpec.describe "Projects", type: :system do
  let(:user) { User.create(email: "test@test.com", password: "password") }

  before do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"
  end

  it "создаёт новый проект" do
    visit new_project_path

    fill_in "project_title", with: "Мой проект"
    fill_in "project_description", with: "Описание проекта"
    click_button "Создать проект"

    expect(page).to have_content("Мой проект")
  end
end
