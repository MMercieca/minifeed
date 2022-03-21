class SyncKnownAndMiniFeeds < ActiveRecord::Migration[7.0]
  def change
    rename_column :known_mini_feeds, :episodes_identifier, :episode_prefix
  end
end
