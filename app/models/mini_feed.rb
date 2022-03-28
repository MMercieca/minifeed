class MiniFeed < ApplicationRecord
  belongs_to :main_feed
  has_one_attached :image
  default_scope { order(name: :asc) }

  def episodes(rss = nil)
    if !rss
      rss = main_feed.fetch
    end

    return [] unless rss

    if itunes_season
      return episodes_by_season(rss, itunes_season)
    end

    if start_date && end_date
      return episodes_by_dates(rss, start_date, end_date) 
    end

    if start_date
      return episodes_by_start_date(rss, start_date)
    end

    if end_date
      return episodes_by_end_date(rss, end_date)
    end

    episodes_by_prefix(rss)
  end

  def episodes_by_season(rss, season)
    episodes = []

    all_episodes = rss.xpath("/rss/channel/item")
    all_episodes.each do |episode|
      season_text = episode.xpath("itunes:season").text
      next unless season
      
      if season_text.to_i == season
        episodes << episode
      end
    end

    episodes
  end

  def episodes_by_start_date(rss, start_date)
    episodes = []

    all_episodes = rss.xpath("/rss/channel/item")
    all_episodes.each do |episode|
      date = episode.xpath("pubDate")
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

    all_episodes = rss.xpath("/rss/channel/item")
    all_episodes.each do |episode|
      date = episode.xpath("pubDate").text
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

    all_episodes = rss.xpath("/rss/channel/item")
    all_episodes.each do |episode|
      date = episode.xpath("pubDate")
      next unless date
      date = Date.parse(date)
      next unless date

      if date <= end_date && date >= start_date
        episodes << episode
      end
    end

    episodes
  end

  def episodes_by_prefix(rss)
    episodes = []

    all_episodes = rss.xpath("/rss/channel/item")
    all_episodes.each do |episode|
      title = episode.xpath("title").text
      if title.starts_with?(episode_prefix)
        episodes << episode
      end
    end

    episodes
  end

  def polled_at
    return nil unless episodes && episodes.count > 0

    pubDate = episodes.first.elements.select { |e| e.name == "pubDate" }[0].text
    return nil if pubDate.blank?
    
    DateTime.parse(pubDate)
  end

  def url(protocol = "https://", host = "minicast.app")
    "#{protocol}#{host}/feeds/#{main_feed.identifier}/#{id}.xml"
  end
end
