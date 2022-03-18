class CreateMiniFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :mini_feeds do |t|
      t.references :main_feed, null: false, foreign_key: true
      t.string :episode_prefix
      t.string :feed_name
      t.xml :episodes
      t.xml :cached_feed

      t.timestamps
    end
  end
end
