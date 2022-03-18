class MiniFeed < ApplicationRecord
  belongs_to :main_feed
  has_one_attached :image
end
