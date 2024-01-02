class CreateStockItems < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_items do |t|
      t.string :name
      t.string :description
      t.string :image
      t.decimal :cost
      t.decimal :price
      t.string :location
      t.boolean :sold

      t.timestamps
    end
  end
end
