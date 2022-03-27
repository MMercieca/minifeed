class KnownFeedsController < ApplicationController
  before_action :authenticate_user!

  def show
    @main_feed = MainFeed.find_by(user: current_user, identifier: params[:identifier])
    @known_feed = KnownFeed.from_main_feed(@main_feed)
    
    if !@main_feed || !@known_feed
      redirect_to main_feeds_url(identifier: params[:identifier]) and return
    end

    @mini_feeds = @known_feed.known_mini_feeds
  end

  def setup_known_feed
    @main_feed = MainFeed.find_by(user: current_user, identifier: params[:identifier])
    @main_feed.setup_known_mini_feeds

    redirect_to main_feeds_url(identifier: @main_feed.identifier)
  end

  def known_feed_params
    params.permit(:identifier)
  end
end