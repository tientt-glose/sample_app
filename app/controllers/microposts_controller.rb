class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.new(micropost_params)
    if @micropost.save
      flash[:success] = t "controllers.microposts.create.succeed"
      redirect_to root_url
    else
      @feed_items = current_user.microposts.created_at_desc.paginate page:
        params[:page], per_page: Settings.per_page
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "controllers.microposts.destroy.succeed"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = t "controllers.microposts.destroy.fail"
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.blank?
  end
end
