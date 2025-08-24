class MainFeed < ApplicationRecord
  has_one_attached :image
  has_many :mini_feeds, dependent: :destroy
  belongs_to :user
  before_save :ensure_unique_identifier
  default_scope { order(name: :asc) }

  def ensure_unique_identifier
    if self.identifier.nil?
      self.identifier = SecureRandom.uuid
    end
  end

  def fetch
    if should_poll?
      rss = URI.open(url).read
      self.update_columns(polled_at: Time.zone.now, cached_feed: rss)
    end

    if !image.attached?
      set_image_from_feed
    end

    Nokogiri(self.cached_feed)
  end

  def should_poll?
    polled_at.nil? || cached_feed.nil? || polled_at < 1.hour.ago
  end

  def self.validate_feed_url(url)
    begin
      feed_xml = URI.open(url).read
      xml = Nokogiri(feed_xml)
      if xml.xpath("/rss/channel").text.blank?
        return false
      end
    rescue
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

  # TODOMPM - setup more known feeds or remove this functionality?  It's not really used anymore.
  def setup_known_mini_feeds
    feed = fetch
    
    known_feed = KnownFeed.from_main_feed(self)
    if known_feed
      # copy known mini feeds to this feed
      self.known_feed_id = known_feed.id
      self.save
      known_feed.known_mini_feeds.each do |known_mini_feed|
        mini_feed = MiniFeed.create!(
          main_feed: self,
          episode_prefix: known_mini_feed.episode_prefix,
          name: known_mini_feed.name,
          itunes_season: known_mini_feed.itunes_season,
          start_date: known_mini_feed.start_date,
          end_date: known_mini_feed.end_date
        )
        mini_feed.image.attach(known_mini_feed.image.blob)
        mini_feed.save

        self.mini_feeds << mini_feed
      end
    end
  end
end
