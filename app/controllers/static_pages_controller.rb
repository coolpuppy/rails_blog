class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feed_items = current_user.feeds.order(created_at: :desc).page(params[:page]).per(5)
    end
  end

  def help
  end

  def contact
  end

  def about
  end
end
