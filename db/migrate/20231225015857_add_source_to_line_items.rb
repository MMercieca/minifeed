class AddSourceToLineItems < ActiveRecord::Migration[7.0]
  def change
    add_column :line_items, :source, :string
  end
end
