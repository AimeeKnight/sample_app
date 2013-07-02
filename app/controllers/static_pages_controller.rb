class StaticPagesController < ApplicationController
 
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      #get users chosen microposts to follow
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
