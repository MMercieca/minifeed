class MainFeedsController < ApplicationController
  before_action :authenticate_user!

  def new
    @main_feed = MainFeed.new(user: current_user)
    respond_to do |format|
      format.html { render :new, locals: { main_feed: @main_feed } }
    end
  end

  def create
    main_feed = MainFeed.new(
      user: current_user,
      name: params[:name],
      url: params[:url]
    )
    main_feed.save
    main_feed.setup_mini_feeds
    

    redirect_to "/"
  end

  def main_feed_params
    params.require(:main_feed).permit(:name, :url)
  end
end