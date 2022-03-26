class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index
  
  def home
  end

  def register
    if current_user
      redirect_to controller: "home", action: "index"
    end
  end

  def dashboard
    @feeds = current_user.main_feeds
  end
end