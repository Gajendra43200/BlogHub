class WelcomeMailer < ApplicationMailer
    def welcome_email
        @user = params[:user]
        mail(to: @user.email, from: 'BlogHub', user: @user, subject: 'Welcome to My Awesome Blog Site')
      end
end
