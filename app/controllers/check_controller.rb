class CheckController < ApplicationController
  def show
  end

  def results
    url = params[:url]
    return redirect_to "/check" if url.blank?

    begin
      xml = RssService.get(url)
    rescue RssFeedMoved => e
      flash[:error] = "The RSS feed has been moved to #{e.message}"
      return redirect_to "/check"
    end

    begin
      @feed = Rss.new(url)
    rescue StandardError => e
      @feed = nil
    end
  end

  def check_params
    params.permit(:url)
  end
end