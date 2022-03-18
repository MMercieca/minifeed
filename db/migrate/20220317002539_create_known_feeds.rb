class CreateKnownFeeds < ActiveRecord::Migration[7.0]
  def change
    create_table :known_feeds do |t|
      t.string :name
      t.string :identifier
      t.time :poll_at

      t.timestamps
    end
  end
end
