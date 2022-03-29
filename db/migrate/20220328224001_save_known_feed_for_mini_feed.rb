class SaveKnownFeedForMiniFeed < ActiveRecord::Migration[7.0]
  def change
    add_column :main_feeds, :known_feed_id, :bigint, default: nil
  end
end
