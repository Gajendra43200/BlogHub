class UsersController < ApplicationController
include Twilio
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      send_email_to_user(@user)
      send_sms_to_user(@user)
      session[:user_id] = @user.id
      if @user.type == "User"
      redirect_to user_path(@user), notice: 'Successfully signed up!'
      elsif @user.type == "Admin"
        redirect_to admin_path(@user), notice: 'Successfully signed up!'
      else
        redirect_to super_admin_path(@user), notice: 'Successfully signed up!'
      end
    else
      render :new
    end
  end

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User was successfully destroyed.'
  end

  def login
  end

  def authenticate
    @user = User.find_by(email: params[:email], password_digest: params[:password_digest])

    if @user
      session[:user_id] = @user.id
      redirect_to @user, notice: 'Successfully logged in!'
    else
      flash[:alert] = 'Wrong email or password'
      render :login
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out successfully'
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password_digest, :type, :name, :phone)
  end

  def send_email_to_user(user)
    WelcomeMailer.with(user:).welcome_email.deliver_now
  end
  def send_sms_to_user(user)
    Twilio::SmsService.new(user.phone).call
  end
end
