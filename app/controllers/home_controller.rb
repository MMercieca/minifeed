class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index, :dashboard]
  
  def home
  end

  def legal
  end

  def privacy
  end

  def contact
  end

  def send_feedback
    user = current_user if current_user

    if !user
      return unless verify_recaptcha
    end

    FeedbackMailer.send_feedback(user, params[:content]).deliver_now

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