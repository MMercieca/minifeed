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
    main_feed.fetch
    main_feed.reload
    
    redirect_to known_feed_url(identifier: main_feed.identifier)
  end

  def index
    @main_feed = MainFeed.find_by(user: current_user, identifier: params[:identifier])

    @mini_feeds = @main_feed.mini_feeds
  end

  def main_feed_params
    params.require(:main_feed).permit(:name, :url)
  end
end