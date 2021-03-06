class MiniFeed < ApplicationRecord
  belongs_to :main_feed
  has_one_attached :image
  default_scope { order(name: :asc) }

  def ensure_feed_image
    if !self.image.attached?
      options = {'width': 400, 'height': 400, 'disable-smart-width': ''}
      kit = IMGKit.new("<html charset='utf-8' style='max-width: 400px; overflow: none; background-color: #134e6f'>
                          <body style='max-width: 400px; overflow: none'>
                            <div style='width: 400px; height: 400px; position: absolute; overflow: none; background-color: #134e6f; text-align: center; font-family: sans-serif; color: white; width: 400px; top: 0; padding-top: 10px;'>
                              <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 448 512'><!--! Font Awesome Free 6.1.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free (Icons: CC BY 4.0, Fonts: SIL OFL 1.1, Code: MIT License) Copyright 2022 Fonticons, Inc. 11547a 135b83 --><path fill='#12577e' d='M224 0C100.3 0 0 100.3 0 224c0 92.22 55.77 171.4 135.4 205.7c-3.48-20.75-6.17-41.59-6.998-58.15C80.08 340.1 48 285.8 48 224c0-97.05 78.95-176 176-176s176 78.95 176 176c0 61.79-32.08 116.1-80.39 147.6c-.834 16.5-3.541 37.37-7.035 58.17C392.2 395.4 448 316.2 448 224C448 100.3 347.7 0 224 0zM224 312c-32.88 0-64 8.625-64 43.75c0 33.13 12.88 104.3 20.62 132.8C185.8 507.6 205.1 512 224 512s38.25-4.375 43.38-23.38C275.1 459.9 288 388.8 288 355.8C288 320.6 256.9 312 224 312zM224 280c30.95 0 56-25.05 56-56S254.1 168 224 168S168 193 168 224S193 280 224 280zM368 224c0-79.53-64.47-144-144-144S80 144.5 80 224c0 44.83 20.92 84.38 53.04 110.8c4.857-12.65 14.13-25.88 32.05-35.04C165.1 299.7 165.4 299.7 165.6 299.7C142.9 282.1 128 254.9 128 224c0-53.02 42.98-96 96-96s96 42.98 96 96c0 30.92-14.87 58.13-37.57 75.68c.1309 .0254 .5078 .0488 .4746 .0742c17.93 9.16 27.19 22.38 32.05 35.04C347.1 308.4 368 268.8 368 224z'/></svg>
                            </div>
                            <h1 style='color: white; font-family: sans-serif; width: 400px; font-size: 3em; position: absolute; top: 30%; left: 5px; text-align: center; display: block'>#{self.name}</h1>
                          </body>
                       </html>", width: 400)
      img = kit.to_img(:png)
      self.image.attach(io: StringIO.new(img.to_s), filename: "#{self.name}.png", content_type: "image/png")
    end
  end

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
      if title.include?(episode_prefix)
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
