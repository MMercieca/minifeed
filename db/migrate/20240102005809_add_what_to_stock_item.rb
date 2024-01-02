class AddWhatToStockItem < ActiveRecord::Migration[7.0]
  def change
    add_column :stock_items, :what, :string
  end
end
