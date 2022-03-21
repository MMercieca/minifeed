class AddIdentifierToMainFeeds < ActiveRecord::Migration[7.0]
  def change
    add_column :main_feeds, :identifier, :string
  end
end
