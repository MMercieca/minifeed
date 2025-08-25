# frozen_string_literal: true

class KnownFeed < ApplicationRecord
  has_many :known_mini_feeds

  def self.known(title)
    KnownFeed.where(identifier: title).first
  end

  def self.from_main_feed(feed)
    title = feed.fetch.xpath('/rss/channel/title').text
    KnownFeed.where('name ilike ?', title).first
  end
end
