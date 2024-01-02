class AddDescriptionToLineItem < ActiveRecord::Migration[7.0]
  def change
    add_column :line_items, :description, :string
    add_column :line_items, :channel, :string
  end
end
