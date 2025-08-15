class FeedsController < ApplicationController
  def show
    main_feed = MainFeed.find_by(identifier: params[:identifier])
    redirect_to "/404" unless main_feed

    @mini_feed = main_feed.mini_feeds.find(params[:id])

    @episodes = @mini_feed.episodes
  end

  def main_feed_xml
    @main_feed_xml ||= MainFeed.find_by(identifier: params[:identifier]).fetch
  end

  def tag_from_main(tag)
    return "" unless main_feed_xml

    begin
      tag = main_feed_xml.xpath(tag).text

      if @mini_feed&.ensure_android_auto_compatability
        XmlHelpers.scrub_emoji(tag)
      end

      tag
    rescue Nokogiri::XML::XPath::SyntaxError
      return ""
    end
  end
  helper_method :tag_from_main

  def add_feed_episode(blob, scrub = false)
    return blob.html_safe unless scrub

    XmlHelpers.scrub_emoji(blob).html_safe
  end
  helper_method :add_feed_episode
  
  def feed_params
    params.permit(:identifier, :id)
  end
end