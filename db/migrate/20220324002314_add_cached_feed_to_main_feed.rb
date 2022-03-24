class AddCachedFeedToMainFeed < ActiveRecord::Migration[7.0]
  def change
    add_column :main_feeds, :cached_feed, :xml
  end
end
