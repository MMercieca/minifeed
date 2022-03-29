class MiniFeedsController < ApplicationController
  before_action :authenticate_user!

  def new
    @main_feed = MainFeed.find_by(identifier: params[:identifier])
  end

  def create
    @main_feed = MainFeed.find_by(identifier: params[:identifier])
    @mini_feed = MiniFeed.create!(
      main_feed: @main_feed,
      name: params[:name],
      start_date: params[:start_date],
      end_date: params[:end_date],
      itunes_season: params[:itunes_season],
      episode_prefix: params[:episode_prefix]
    )
    unless params[:image].blank?
      @mini_feed.image.attach(params[:image])
    end

    @mini_feed.ensure_feed_image

    redirect_to mini_feed_url(identifier: @main_feed.identifier, id: @mini_feed.id)
  end

  def show
    @main_feed = MainFeed.find_by(identifier: params[:identifier])
    @mini_feed = MiniFeed.find_by(main_feed: @main_feed, id: params[:id])
  end

  def update
    @main_feed = MainFeed.find_by(identifier: params[:mini_feed][:identifier])
    @mini_feed = MiniFeed.find_by(main_feed: @main_feed, id: params[:mini_feed][:id])
    
    if !@main_feed || !@mini_feed
      flash["error"] = "Cast not found"
      redirect_to "/dashboard"
      return
    end

    if params[:commit].include?("Delete")
      flash["notice"] = "#{@mini_feed.name} deleted."
      @mini_feed.destroy
      redirect_to main_feeds_url(identifier: @main_feed.identifier) 
      return
    end

    @mini_feed.name = params[:mini_feed][:name]
    @mini_feed.episode_prefix = params[:mini_feed][:episode_prefix]
    @mini_feed.itunes_season = params[:mini_feed][:itunes_season]

    unless params[:mini_feed][:start_date].blank?
      date = Date.parse(params[:mini_feed][:start_date])
      @mini_feed.start_date = date if date
    end

    unless params[:mini_feed][:end_date].blank?
      date = Date.parse(params[:mini_feed][:end_date])
      @mini_feed.end_date = date if date
    end

    @mini_feed.save

    if params[:image]
      @min_feed.image.attach(params[:mini_feed][:image])
    end

    @mini_feed.ensure_feed_image

    flash[:notice] = "Saved"
    redirect_to mini_feed_url(identifier: @main_feed.identifier, id: @mini_feed.id)
  end

  def mini_feed_params
    params.permit(:id, :identifier, :name, :episode_prefix, :image, :start_date, :end_date, :itunes_season)
  end
end