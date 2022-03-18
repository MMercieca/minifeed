class AddFieldsToMainFeed < ActiveRecord::Migration[7.0]
  def change
    add_column :main_feeds, :last_polled_at, :datetime
    add_column :main_feeds, :name, :string
    add_column :main_feeds, :user_id, :bigint
  end
end
