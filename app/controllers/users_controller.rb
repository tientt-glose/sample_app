class UsersController < ApplicationController
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

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user
    redirect_to root_path
    flash[:danger] = t "controllers.users.show.find"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end
end
