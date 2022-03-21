class FeedsController < ApplicationController 
  def show
    main_feed = MainFeed.find_by(identifier: params[:identifier])
    redirect_to "/404" unless main_feed

    @mini_feed = main_feed.mini_feeds.find(params[:id])
    @main_feed_xml = main_feed.fetch

    @episodes = @mini_feed.episodes(@main_feed_xml)
  end

  def main_feed_xml
    @main_feed_xml ||= MainFeed.find_by(identifier: params[:identifier]).fetch
  end

  def tag_from_main(tag)
    return "" unless main_feed_xml
    main_feed_xml.xpath(tag).text
  end
  helper_method :tag_from_main
  
  def feed_params
    params.permit(:identifier, :id)
  end
end