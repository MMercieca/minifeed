class KnownMiniFeed < ApplicationRecord
  belongs_to :known_feed
  has_one_attached :image
end
