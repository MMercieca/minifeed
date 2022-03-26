class MakeMainAndMiniFeedsConsistent < ActiveRecord::Migration[7.0]
  def change
    rename_column :mini_feeds, :feed_name, :name
    remove_column :main_feeds, :last_polled_at
    remove_column :mini_feeds, :episodes
    remove_column :mini_feeds, :cached_feed
  end
end
