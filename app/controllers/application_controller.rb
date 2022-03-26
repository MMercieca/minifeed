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
end
