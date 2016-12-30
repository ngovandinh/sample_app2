class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :edit]
  before_action :correct_user,   only: [:destroy, :update]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
       @feed_items = []
      render 'static_pages/home'
    end
  end

  def update
    if @micropost.update_attributes(micropost_params)
      flash[:success] = "Micropost is updated"
    else
      flash[:danger] = "Updated micropost is failed"
    end  
      redirect_to request.referrer || root_url
  end

  def destroy
  	@micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url

  end

  private

    def micropost_params
        params.require(:micropost).permit(:content, :picture, :title)
    end
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
