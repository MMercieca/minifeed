class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @feeds = current_user.main_feeds
  end
end