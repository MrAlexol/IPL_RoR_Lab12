class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  skip_before_action :require_login, only: %i[new create]

  # GET /users or /users.json
  def index
    if current_user.admin?
      @users = User.all
    else
      redirect_to '/403'
    end
  end

  # GET /users/1 or /users/1.json
  def show
    redirect_to '/403' unless current_user.id == @user.id || current_user.admin?
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    redirect_to '/403' unless current_user.id == @user.id || current_user.admin?
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html do
          flash[:success] = 'Пользователь успешно создан'
          redirect_to @user
        end
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if current_user.id == @user.id || current_user.admin?
      respond_to do |format|
        if @user.update(user_params)
          format.html do
            flash[:success] = 'Параметры пользователя успешно обновлены'
            redirect_to @user
          end
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :forbidden }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if current_user.id == @user.id || current_user.admin?
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :forbidden }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      if current_user.nil? || !current_user.admin?
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      else
        params.require(:user).permit(:username, :email, :password, :password_confirmation, :admin)
      end
    end
end
