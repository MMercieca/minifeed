class KnownMiniFeedNameUpdate < ActiveRecord::Migration[7.0]
  def change
    rename_column :known_mini_feeds, :feed_name, :name
  end
end
