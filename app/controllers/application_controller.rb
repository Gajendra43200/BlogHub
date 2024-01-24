class ApplicationController < ActionController::Base
    helper_method :current_user
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    private
    def record_not_found
     render josn: {error: 'Record not found.'}
    end
    
    def current_user
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end  

end
