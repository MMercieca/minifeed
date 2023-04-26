class CheckController < ApplicationController
  def show
  end

  def results
    url = params[:url]
    @feed = Rss.new(url)
  end

  def check_params
    params.permit(:url)
  end
end