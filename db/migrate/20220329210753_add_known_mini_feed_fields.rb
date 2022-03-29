class AddKnownMiniFeedFields < ActiveRecord::Migration[7.0]
  def change
    add_column :known_mini_feeds, :start_date, :datetime
    add_column :known_mini_feeds, :end_date, :datetime
    add_column :known_mini_feeds, :itunes_season, :integer
  end
end
