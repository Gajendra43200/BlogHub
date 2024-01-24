class UsersController < ApplicationController
include Twilio
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user = User.new(user_params)

    if @user.save
      send_notifications(@user)
      set_session_and_redirect(@user)
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
      redirect_to @user, alert: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, alert: 'User and user comments was successfully destroyed.'
  end

  def login
  end

  def authenticate
    @user = User.find_by(email: params[:email], password_digest: params[:password_digest])

    if @user
      session[:user_id] = @user.id
      redirect_to @user, alert: 'Successfully logged in!'
    else
      flash[:alert] = 'Wrong email or password'
      render :login
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to login_path, alert: 'Logged out successfully'
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password_digest, :type, :name, :phone)
  end

  def send_notifications(user)
    WelcomeMailer.with(user:).welcome_email.deliver_now
    Twilio::SmsService.new(user.phone).call
  end
  
  def set_session_and_redirect(user)
    session[:user_id] = user.id
  
    redirect_path = case user.type
                    when "User" then user_path(user)
                    when "Admin" then admin_path(user)
                    else super_admin_path(user)
                    end
    redirect_to redirect_path, alert: 'Successfully signed up!'
   end
end
