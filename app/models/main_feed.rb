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
    if polled_at.nil? || cached_feed.nil? || polled_at < 1.hour.ago 
      feed_xml = URI.open(url).read
      self.polled_at = Time.zone.now
      self.cached_feed = feed_xml
      self.save
      self.reload
    end

    if !self.image.attached?
      set_image_from_feed
    end

    feed_xml = self.cached_feed
    Nokogiri(feed_xml)
  end

  def self.validate_feed_url(url)
    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      return false
    end

    feed_xml = URI.open(url).read
    xml = Nokogiri(feed_xml)
    if xml.xpath("/rss/channel").text.blank?
      return false
    end
    
    true
  end

  def set_image_from_feed
    image_url = Nokogiri(self.cached_feed).xpath('/rss/channel/image/url').text
    image = URI.parse(image_url).open
    self.image.attach(io: image, filename: 'logo.png')
  end

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

  def poll!
    rss = fetch
    feeds = {}
    mini_feeds.each do |mini|
      feeds[mini.feed_name] = []
    end
    
    episodes = rss.xpath("/rss/channel/item")
    episodes.each do |episode|
      title = episode.xpath("title").text

      mini_feeds.each do |mini|
        if title.starts_with?(mini.episode_prefix)
          feeds[mini.feed_name] << episode
        end
      end
    end
    feeds
  end
end
