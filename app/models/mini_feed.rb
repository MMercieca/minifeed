class MiniFeed < ApplicationRecord
  belongs_to :main_feed
  has_one_attached :image
  default_scope { order(name: :asc) }
  before_save :ensure_feed_image
  validate :one_feed_setting

  def one_feed_setting
    if itunes_season && (start_date || end_date || episode_prefix)
      errors.add(:self, 'Cannot set dates or title words when specifying an iTunes season')
    end

    if (start_date || end_date) && episode_prefix
      errors.add(:self, 'Cannot set title words when specifying start or end date')
    end
  end

  def ensure_feed_image
    if !self.image.attached?
      img = Poster.generate(name)

      self.image.attach(io: StringIO.new(img.to_blob), filename: "#{self.name}.png", content_type: "image/png")
    end
  end

  def episodes
    return episodes_by_season(rss, itunes_season) if itunes_season
    return episodes_by_dates(rss, start_date, end_date) if start_date && end_date
    return episodes_by_start_date(rss, start_date) if start_date
    return episodes_by_end_date(rss, end_date) if end_date
    return episodes_by_title(rss) if episode_prefix

    all_episodes
  end

  def polled_at
    return nil unless episodes && episodes.count > 0

    pubDate = episodes.first.elements.select { |e| e.name == "pubDate" }[0].text
    return nil if pubDate.blank?
    
    DateTime.parse(pubDate)
  end

  def url(protocol = "https://", host = "minicast.app")
    if Rails.env.development?
      host = "localhost:3000"
      protocol = "http://"
    end

    "#{protocol}#{host}/feeds/#{main_feed.identifier}/#{id}.xml"
  end

  private

  def rss
    rss = main_feed.fetch
    return [] unless rss

    rss.remove_namespaces!
  end

  def all_episodes
    rss.xpath("//rss/channel/item")
  end

  def episodes_by_season(rss, season)
    episodes = []
    
    all_episodes.each do |episode|
      season_number = nil
      episode.elements.each do |el|
        next unless season_number.nil? && el.name == "itunes:season"

        season_number = el.text.to_i
      end
      
      next unless season_number

      if season_number == season
        episodes << episode
      end
    end

    episodes
  end

  def episodes_by_start_date(rss, start_date)
    episodes = []

    all_episodes.each do |episode|
      date = episode.xpath("pubdate")&.children&.first&.text
      next unless date

      date = Date.parse(date)
      next unless date

      if date >= start_date
        episodes << episode
      end
    end

    episodes
  end

  def episodes_by_end_date(rss, end_date)
    episodes = []

    all_episodes.each do |episode|
      date = episode.xpath("pubdate")&.children&.first&.text
      next unless date

      date = Date.parse(date)
      next unless date

      if date <= end_date
        episodes << episode
      end
    end

    episodes
  end

  def episodes_by_dates(rss, start_date, end_date)
    episodes = []

    all_episodes.each do |episode|
      date = episode.xpath("pubdate")&.children&.first&.text
      next unless date

      date = Date.parse(date)
      next unless date

      if date <= end_date && date >= start_date
        episodes << episode
      end
    end

    episodes
  end

  def episodes_by_title(rss)
    episodes = []

    all_episodes.each do |episode|
      title = episode.xpath("title").text
      if title.include?(episode_prefix)
        episodes << episode
      end
    end

    episodes
  end
end
