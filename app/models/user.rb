class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable if Rails.env.development?
  devise :database_authenticatable, :rememberable, :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :main_feeds
end
