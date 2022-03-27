class AddItunesSeasonToMiniFeed < ActiveRecord::Migration[7.0]
  def change
    add_column :mini_feeds, :itunes_season, :integer
  end
end
