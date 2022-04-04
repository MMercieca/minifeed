class ApplicationController < ActionController::Base
  before_action do
    ActiveStorage::Current.host = 'http://localhost:3000' if Rails.env.development?
  end

  # unless Rails.application.config.consider_all_requests_local
  #   rescue_from Exception, with: :render_500
  # end

  # def render_500(exception)
  #   # logger.
  # end

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

  def show_dashboard_link?
    return false unless current_user
    return true if request.path.length < 2
    ["legal", "privacy", "terms", "contact"].each do |path|
      return true if request.path.include?(path)
    end
    false
  end
  helper_method :show_dashboard_link?

  def build_breadcrumbs(links)
    breadcrumbs = ""

    links.each do |link|
      if link[0].nil?
        breadcrumbs = "  #{breadcrumbs}  <span class='text-m font-bold leading-relaxed inline-block px-2 py-2 whitespace-nowrap uppercase text-slate-700'>#{link[1]}</span>"
      else
        breadcrumbs = "  #{breadcrumbs}  <a class='text-m font-bold leading inline-block px-2 whitespace-nowrap uppercase text-slate-700' href='#{link[0]}'>#{link[1]}</a>"
      end
    end
    breadcrumbs.html_safe
  end
  helper_method :build_breadcrumbs
end
