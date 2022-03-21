class MiniFeed < ApplicationRecord
  belongs_to :main_feed
  has_one_attached :image

  def episodes
    rss = main_feed.fetch
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
end
