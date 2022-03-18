class CreateMainFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :main_feeds do |t|
      t.string :url
      t.datetime :polled_at

      t.timestamps
    end
  end
end
