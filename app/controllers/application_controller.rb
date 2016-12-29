class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

    def logged_in_user
      unless session[:user_id]
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end
end
