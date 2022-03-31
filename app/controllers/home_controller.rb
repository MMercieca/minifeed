class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index, :send_feedback, :dashboard]
  
  def home
  end

  def legal
  end

  def privacy
  end

  def contact
  end

  def send_feedback
    return unless current_user
    FeedbackMailer.send_feedback(current_user, params[:content]).deliver_now
    flash[:notice] = "Feedback sent"
    render "contact"
  end

  def register
    if current_user
      redirect_to "/dashboard"
    end
  end

  def dashboard
    @feeds = current_user.main_feeds
  end
end