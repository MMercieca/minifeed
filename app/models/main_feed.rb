# frozen_string_literal: true

class MainFeed < ApplicationRecord
  has_one_attached :image
  has_many :mini_feeds, dependent: :destroy
  belongs_to :user
  before_save :ensure_unique_identifier
  default_scope { order(name: :asc) }

  def ensure_unique_identifier
    return unless identifier.nil?

    self.identifier = SecureRandom.uuid
  end

  def fetch
    if should_poll?
      rss = URI.open(url).read
      update_columns(polled_at: Time.zone.now, cached_feed: rss)
    end

    set_image_from_feed unless image.attached?

    Nokogiri(cached_feed)
  end

  def should_poll?
    polled_at.nil? || cached_feed.nil? || polled_at < 1.hour.ago
  end

  def self.validate_feed_url(url)
    begin
      feed_xml = URI.open(url).read
      xml = Nokogiri(feed_xml)
      return false if xml.xpath('/rss/channel').text.blank?
    rescue StandardError
      return false
    end

    true
  end

  def set_image_from_feed
    return if cached_feed.blank?

    feed = Nokogiri(cached_feed)
    image_url = feed.xpath('/rss/channel/image/url').text
    image_url = feed.xpath('/rss/channel/itunes:image/@href').text if image_url.blank?
    return if image_url.blank?

    logo = URI.parse(image_url).open
    image.attach(io: logo, filename: 'logo.png')
  end
end
