class CommentsController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:destroy, :update]
  def show
  end
	def create
		@comment= current_user.comments.build(comment_params)
		if @comment.save
      		flash[:success] = "Comment created!"
      		redirect_to request.referrer || root_url
    	else
      	 	@feed_items = []
          flash[:danger] = "Comment failed!"
      		render 'static_pages/home'
    	end
	end

  def update
    if @comment.update_attributes(comment_params)
      flash[:success] = "Comment is updated"
    else
      flash[:danger] = "Updated comment is failed"
    end  
      redirect_to request.referrer || root_url
  end

	def destroy
	  	@comment.destroy
	    flash[:success] = "Comment deleted"
	    redirect_to request.referrer || root_url
  end


	private

    def comment_params
        params.require(:comment).permit(:content, :micropost_id)
    end
    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end
end
