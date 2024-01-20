class AdminsController < ApplicationController
  before_action :check_admin, except: [:login, :authenticate]
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:block_user, :unblock_user]
  before_action :set_comment_for_approval, only: [:approve_comment]

  def new
    @user = User.new
  end

  def create
    @user = User.new(admin_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to admin_path, notice: 'Successfully signed up!'
    else
      render :new
    end
  end

  def index
    @admins = User.where(type: "Admin")
  end

  def edit
  end

  def update
    if @admin_user.update(admin_params)
      redirect_to @admin_user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def show
    @admin_user = Admin.find(params[:id])
  end

  def destroy
    @admin_user.destroy
    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  def block_user
    if @user.nil? 
      render json: { message: "User not found for this id" }
    else
      @user.update(status: "block") 
      render json: { user: @user, user_status: @user.status }
    end
  end

  def unblock_user
    @user.update(status: "unblock")
    render json: { user: @user, user_status: @user.status }
  end

  def all_comments
    @comments = Comment.where(status: "pending")
  end

  def approve_comment
    if @comment&.status == "pending"
      @comment.update(status: "approved")
      redirect_to approve_comments_path
    else
      redirect_to approve_comments_path  
    end
  end

  private

  def set_admin
    @admin_user = Admin.find(params[:id])
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end

  def set_comment_for_approval
    @comment = Comment.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:email, :password_digest, :type, :name, :phone)
  end

  def check_admin
    if current_user.nil?
      redirect_to login_path
    elsif current_user.type == "Admin"
    else
      redirect_to login_path, alert: 'Please login'
    end
  end
end
