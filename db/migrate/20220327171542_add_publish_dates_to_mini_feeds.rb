class AddPublishDatesToMiniFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :mini_feeds, :start_date, :datetime, default: nil
    add_column :mini_feeds, :end_date, :datetime, defailt: nil
    add_column :known_feeds, :url, :string
  end
end
