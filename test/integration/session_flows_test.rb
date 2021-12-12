# frozen_string_literal: true

require "test_helper"

class SessionFlowsTest < ActionDispatch::IntegrationTest
  fixtures :users

  test 'unauthorized user will see login page' do
    get root_path
    assert_response :success, controller: :session, action: :login
  end

  test 'user with incorrect credentials will be redirected to login page' do
    username = Faker::Internet.username
    email = Faker::Internet.email
    password = Faker::Internet.password(min_length: 6)
    user = User.create(username: username, email: email, password: password, password_confirmation: password)
    post session_create_url, params: { username: user.username, password: "#{user.password}D" }
    assert_redirected_to session_login_path
  end

  test 'user with correct credentials will see sequence input' do
    username = Faker::Internet.username
    email = Faker::Internet.email
    password = Faker::Internet.password(min_length: 6)
    user = User.create(username: username, email: email, password: password, password_confirmation: password)
    post session_create_path, params: { login: user.username, password: user.password }
    assert_redirected_to root_path
  end

  test 'user can logout' do
    username = Faker::Internet.username
    email = Faker::Internet.email
    password = Faker::Internet.password(min_length: 6)
    user = User.create(username: username, email: email, password: password, password_confirmation: password)

    post session_create_url, params: { login: user.username, password: password }
    get session_logout_path

    assert_redirected_to session_login_path
  end
end
