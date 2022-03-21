class KnownFeed < ApplicationRecord
  has_many :known_mini_feeds
  
  def self.known(title)
    KnownFeed.where(identifier: title).first
  end
end
