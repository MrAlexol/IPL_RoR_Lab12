# frozen_string_literal: true

class SessionController < ApplicationController
  skip_before_action :require_login, only: %i[login create]

  def login
    redirect_to sequence_input_path if signed_in?
  end

  def create
    user = User.find_by(username: params[:login])

    if user&.authenticate(params[:password])
      sign_in user
      redirect_to root_path
    else
      flash[:danger] = user.nil? ? 'Пользователь с таким именем не существует' : 'Неверный пароль'
      redirect_to session_login_path
    end
  end

  def logout
    sign_out
    redirect_to session_login_path
  end
end
