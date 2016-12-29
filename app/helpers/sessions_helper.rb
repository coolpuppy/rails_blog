module SessionsHelper
  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def current_user?(user)
    current_user == user
  end

  def logged_in?
    !session[:user_id].nil?
  end
end
