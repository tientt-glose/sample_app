class UsersController < ApplicationController
  before_action :find_user, only: %i[show edit destroy]
  before_action :logged_in_user, only: %i[index edit destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page], per_page: Settings.per_page
  end

  def show
    return if @user
    flash[:danger] = t "controllers.users.show.message"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "users.new.u_message"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t ".message"
      redirect_to @user
    else
      flash[:danger] = t "controllers.users.show.message"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users.destroy.message"
      redirect_to users_url
    else
      flash[:danger] = t "controllers.users.show.message"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation, :admin)
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users.logged_in_user.message"
    redirect_to login_url
  end

  def correct_user
    return if current_user.current_user?(@user)
    flash[:danger] = t "controllers.users.correct_user.message"
    redirect_to edit_user_path(current_user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".cannot_find_user"
    redirect_to root_url
  end
end
