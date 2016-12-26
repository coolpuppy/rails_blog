class SessionsController < ApplicationController
  def new
  end

  def create

    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate?(params[:session][:password])
      log_in(user)
      @current_user = user
      if params[:session][:remember_me] == '1'

      end
      puts "Logged in succeed!!!!"
      redirect_to user
    else
      puts "Logged in failed!!!"
      flash.now[:danger] = 'Invalid email/password'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to users_url
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
