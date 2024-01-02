class AddFieldsToStockItems < ActiveRecord::Migration[7.0]
  def change
    add_column :stock_items, :glaze, :string
  end
end
