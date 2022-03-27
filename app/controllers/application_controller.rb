class ApplicationController < ActionController::Base
  before_action do
    ActiveStorage::Current.host = 'http://localhost:3000' if Rails.env.development?
  end

  def authenticate_admin!
    return not_found unless current_user && current_user.is_admin?
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def current_admin_user
    return current_user if current_user && current_user.is_admin?
    nil
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || dashboard_path
  end

  def format_date(date)
    return "?" unless date
    date.strftime("%B %d, %Y")
  end
  helper_method :format_date

  def build_breadcrumbs(links)
    breadcrumbs = ""

    links.each do |link|
      if link[0].nil?
        breadcrumbs = "#{breadcrumbs} #{link[1]}"
      else
        breadcrumbs = "#{breadcrumbs} <a href='#{link[0]}'>#{link[1]}</a> &gt; "
      end
    end
    breadcrumbs.html_safe
  end
  helper_method :build_breadcrumbs
end
