require "rails_helper"

RSpec.describe "Devise", type: :request do
  it "показывает страницу регистрации" do
    get new_user_registration_path
    expect(response).to have_http_status(:ok)
  end

  it "показывает страницу входа" do
    get new_user_session_path
    expect(response).to have_http_status(:ok)
  end

  it "регистрирует пользователя" do
    expect do
      post user_registration_path, params: {
        user: {
          email: "new@test.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end.to change { User.count }.by(1)
  end

  it "не регистрирует с коротким паролем" do
    expect do
      post user_registration_path, params: {
        user: {
          email: "new@test.com",
          password: "123",
          password_confirmation: "123"
        }
      }
    end.not_to(change { User.count })
  end

  it "логинит пользователя" do
    user = User.create(email: "test@test.com", password: "password")
    post user_session_path, params: {
      user: {
        email: user.email,
        password: "password"
      }
    }
    expect(response).to redirect_to(root_path(locale: "ru"))
  end

  it "не логинит с неверным паролем" do
    user = User.create(email: "test@test.com", password: "password")
    post user_session_path, params: {
      user: {
        email: user.email,
        password: "wrong"
      }
    }
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
