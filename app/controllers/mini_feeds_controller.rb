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
      episode_prefix: params[:episode_prefix]
    )
    unless params[:image].blank?
      @mini_feed.image.attach(params[:image])
    end

    redirect_to mini_feed_url(identifier: @main_feed.identifier, id: @mini_feed.id)
  end

  def show
    @main_feed = MainFeed.find_by(identifier: params[:identifier])
    @mini_feed = MiniFeed.find_by(main_feed: @main_feed, id: params[:id])
  end

  def update
    @main_feed = MainFeed.find_by(identifier: params[:mini_feed][:identifier])
    @mini_feed = MiniFeed.find_by(main_feed: @main_feed, id: params[:mini_feed][:id])

    @mini_feed.name = params[:mini_feed][:name]
    @mini_feed.episode_prefix = params[:mini_feed][:episode_prefix]
    @mini_feed.save

    if params[:image]
      @min_feed.image.attach(params[:mini_feed][:image])
    end

    flash[:notice] = "Saved"
    redirect_to mini_feed_url(identifier: @main_feed.identifier, id: @mini_feed.id)
  end

  def mini_feed_params
    params.permit(:id, :identifier, :name, :episode_prefix, :image)
  end
end