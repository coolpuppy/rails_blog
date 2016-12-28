class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in_user
    unless session[:user_id]
      flash[:danger] = "Please log in"
      redirect_to login_url
    end
  end
end
