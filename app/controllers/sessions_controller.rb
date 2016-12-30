class SessionsController < ApplicationController
  before_action :redirect_to_user, :only => :new

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate?(params[:session][:password])
      log_in(user)
      @current_user = user
      if params[:session][:remember_me] == '1'
        cookies[:user_id] = {value: user.id, expires: 2.weeks.from_now.utc}
        cookies[:user_token] = {value: user.gen_token, expires: 2.weeks.from_now.utc}
      end
      redirect_to @current_user
    else
      flash.now[:danger] = 'Invalid email/password'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def redirect_to_user
    redirect_to user_url(current_user) if logged_in?
  end

end
