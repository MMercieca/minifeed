class FeedsController < ApplicationController 
  def show
    main_feed = MainFeed.find_by(identifier: params[:identifier])
    redirect_to "/404" unless main_feed

    @mini_feed = main_feed.mini_feeds.find(params[:id])
    
    @episodes = @mini_feed.episodes
  end

  def feed_params
    params.permit(:identifier, :id)
  end
end