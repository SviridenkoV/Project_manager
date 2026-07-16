require 'rails_helper'

RSpec.describe "projects/index", type: :view do
  let(:user) { User.create(email: "test@test.com", password: "password") }

  before do
    allow(view).to receive(:user_signed_in?).and_return(true)
    allow(view).to receive(:current_user).and_return(user)
  end

  it "показывает сообщение, если нет проектов" do
    assign(:projects, [])
    render
    expect(rendered).to match(/У вас пока нет проектов/)
  end

  it "показывает список проектов" do
    projects = [
      Project.create(title: "Проект 1", user: user),
      Project.create(title: "Проект 2", user: user)
    ]
    assign(:projects, projects)
    render
    expect(rendered).to match(/Проект 1/)
    expect(rendered).to match(/Проект 2/)
  end
end