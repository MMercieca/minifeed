class CreateKnownMiniFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :known_mini_feeds do |t|
      t.references :known_feed, null: false, foreign_key: true
      t.string :episodes_identifier
      t.string :feed_name

      t.timestamps
    end
  end
end
