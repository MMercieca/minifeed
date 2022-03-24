class MiniFeed < ApplicationRecord
  belongs_to :main_feed
  has_one_attached :image

  def episodes(rss = nil)
    if !rss
      rss = main_feed.fetch
    end

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

  def url(host = "https://minicast.app")
    "#{host}/feeds/#{main_feed.identifier}/#{id}.xml"
  end
end
