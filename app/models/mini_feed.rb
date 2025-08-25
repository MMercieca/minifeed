# frozen_string_literal: true

class MiniFeed < ApplicationRecord
  belongs_to :main_feed
  has_one_attached :image
  default_scope { order(name: :asc) }
  before_save :ensure_feed_image
  validate :one_feed_setting

  def one_feed_setting
    if itunes_season && (start_date.present? || end_date.present? || episode_prefix.present?)
      errors.add(:self, 'Cannot set dates or title words when specifying an iTunes season')
    end

    return unless (start_date.present? || end_date.present?) && episode_prefix.present?

    errors.add(:self, 'Cannot set title words when specifying start or end date')
  end

  def ensure_feed_image
    return if image.attached?

    img = Poster.generate(name)

    image.attach(io: StringIO.new(img.to_blob), filename: "#{name}.png", content_type: 'image/png')
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
    return nil unless episodes&.count&.positive?

    pubDate = date_for_episode(episodes.first)
    return nil if pubDate.blank?

    DateTime.parse(pubDate)
  end

  def url(protocol = 'https://', host = 'minicast.app')
    if Rails.env.development?
      host = 'localhost:3000'
      protocol = 'http://'
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
    rss.xpath('//rss/channel/item')
  end

  def episodes_by_season(_rss, season)
    episodes = []

    all_episodes.each do |episode|
      season_number = nil
      episode.elements.each do |el|
        next if season_number.present? || (el.name != 'itunes:season' && el.name != 'season')

        season_number = el.text.to_i
      end

      next unless season_number

      episodes << episode if season_number == season
    end

    episodes
  end

  def episodes_by_start_date(_rss, start_date)
    episodes = []

    all_episodes.each do |episode|
      date = date_for_episode(episode)
      next unless date

      date = Date.parse(date)
      next unless date

      episodes << episode if date >= start_date
    end

    episodes
  end

  def episodes_by_end_date(_rss, end_date)
    episodes = []

    all_episodes.each do |episode|
      date = date_for_episode(episode)
      next unless date

      date = Date.parse(date)
      next unless date

      episodes << episode if date <= end_date
    end

    episodes
  end

  def episodes_by_dates(_rss, start_date, end_date)
    episodes = []

    all_episodes.each do |episode|
      date = date_for_episode(episode)
      next unless date

      date = Date.parse(date)
      next unless date

      episodes << episode if date <= end_date && date >= start_date
    end

    episodes
  end

  def episodes_by_title(_rss)
    episodes = []

    all_episodes.each do |episode|
      title = episode.xpath('title').text
      episodes << episode if title.include?(episode_prefix)
    end

    episodes
  end

  def date_for_episode(episode)
    date = episode.xpath('pubdate')&.children&.first&.text
    date ||= episode.xpath('pubDate')&.children&.first&.text

    date
  end
end
