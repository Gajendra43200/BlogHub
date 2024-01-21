class SuperAdminsController < ApplicationController
  before_action :check_super_admin
  before_action :set_super_admin, only: [:show, :edit, :update]

  def show
    @super_admin = User.find(params[:id])
  end

  def edit
  end

  def update
    if @super_admin.update(super_admin_params)
      redirect_to @super_admin, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def all_comments
    @comments = Comment.where(status: "approved")
    flash[:notice] = "Comments do not exist for approval." if @comments.empty?
  end

  def approve_comment_by_super_admin
    @comment = Comment.find_by(id: params[:id])

    if @comment.present? && @comment.status == "approved"
      @comment.update(status: "super_admin_approved")
      redirect_to approval_comments_path
    else
      redirect_to approval_comments_path, alert: "Comment does not exist for approval."
    end
  end

  private

  def set_super_admin
    @super_admin = SuperAdmin.find(params[:id])
  end

  def super_admin_params
    params.require(:super_admin).permit(:email, :password_digest, :type, :name, :phone)
  end

  def check_super_admin
    redirect_to root_path, alert: 'Invalid email or password' unless current_user.is_a?(SuperAdmin)
  end
end
