class DropLedger < ActiveRecord::Migration[7.0]
  def change
    drop_table :line_items
    drop_table :stock_items
  end
end
