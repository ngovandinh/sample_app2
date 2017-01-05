class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy, :following, :followers, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page], per_page: 5)
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 5)
    render 'show_follow'
  end



  def index
    #@users = User.all
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def show
  	@user = User.find(params[:id])
    # @comment = current_user.comments.build  
    # @microposts = @user.microposts.paginate(page: params[:page], per_page: 5)
    # @feed_items = @user.feed.paginate(page: params[:page], per_page: 5)
  end

  def new
  	@user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      # Handle a successful save.
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url

      # log_in @user
      # flash.now[:success] = "Welcome #{@user.name} to the Sample App!"
      # redirect_to @user

    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user

    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # def logged_in_user
    #   unless logged_in?
    #     store_location
    #     flash[:danger] = "Please log in."
    #     redirect_to login_url
    #   end
    # end	 

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end 
end
