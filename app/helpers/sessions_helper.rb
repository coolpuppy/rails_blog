module SessionsHelper
  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def current_user?(user)
    current_user == user
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    cookies.delete(:user_id)
    cookies.delete(:user_token)
    @current_user = nil
  end

  def logged_in?
    log_in_from_cookie? || !session[:user_id].nil?
  end

  def log_in_from_cookie?
    if !cookies[:user_id] || !cookies[:user_token]
      return false
    else
      begin
        @current_user = User.find(cookies[:user_id])
      rescue
        @current_user = nil
        return false
      end
      if @current_user.gen_token != cookies[:user_token]
        @current_user = nil
        return false
      else
        log_in(@current_user)
      end
    end
    return true
  end
end
