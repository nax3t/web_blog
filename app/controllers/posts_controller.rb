class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    if user_signed_in?
      @post = Post.new
    else
      redirect_to new_user_session_path
      flash.notice = "You need to sign in first"
    end
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.find params[:id]
  end

  def edit
    @post = Post.find params[:id]
    if @post.user == current_user
      render 'edit'
    else
      redirect_to posts_path
      flash.alert = "Invalid Permissions"
    end
  end

  def update
    @post = Post.find params[:id]
    if @post.update post_params
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find params[:id]
    if @post.user = current_user
      @post.destroy
      redirect_to posts_path
      flash.notice = "Post successfully deleted"
    else
      redirect_to posts_path
      flash.notice = "Invalid Permissions"
    end
  end

  private
    def post_params
      params.require(:post).permit(:author, :title, :body)
    end
end
