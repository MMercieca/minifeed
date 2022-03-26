class ApplicationController < ActionController::Base
  before_action do
    ActiveStorage::Current.host = 'http://localhost:3000' if Rails.env.development?
  end
end
