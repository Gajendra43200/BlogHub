class CommentsController < ApplicationController
  # before_action :authenticate_request, only: %i[create]
  before_action :check_user, only: [:new, :create]
  before_action :set_commentable, except: :index

  def new
    @comment = Comment.new
  end

  def create
    UpdateCommentJob.set(wait: 1.minute).perform_later(comment_params, current_user, @commentable)
    if current_user.type == "Admin"
     redirect_to admin_path(current_user.id),  alert: "Comment update in the database after one minute"
    elsif current_user.type == "SuperAdmin"
     redirect_to super_admin_path(current_user.id),  alert: "Comment update in the database after one minute"
    else
     redirect_to user_path(current_user.id),  alert: "Comment update in the database after one minute"
    end
  end

  def index
    @comments_blog = Comment.where(commentable_type: "Blog")
    @comments_author = Comment.where(commentable_type: "Author")
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def check_user
    unless current_user_is_valid?
      render json: { message: "Only unblocked users can create comments." }
    end
    set_commentable
  end

  def current_user_is_valid?
    if params[:user_id].present?
      current_user.present? && current_user.status == "unblock" && current_user.id == params[:user_id].to_i 
    elsif params[:admin_id].present?
      current_user.present? && current_user.status == "unblock" && current_user.id == params[:admin_id].to_i 
    else
       current_user.present? && current_user.status == "unblock" && current_user.id == params[:super_admin_id].to_i 
    end
  end

  def set_commentable
    @commentable = find_commentable
    render json: { message: "Please provide a valid commentable id." } unless @commentable
  end

  def find_commentable
    return Author.find(params[:author_id]) if params[:author_id]
    return Blog.find(params[:blog_id]) if params[:blog_id]
    nil
  end

  def redirect_to_commentable_path
    redirect_to @comment.commentable_type == "Author" ? user_author_comments_path : user_blog_comments_path
  end
end
