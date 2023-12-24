class CreateLineItems < ActiveRecord::Migration[7.0]
  def change
    create_table :line_items do |t|
      t.string :name
      t.date :entry_date
      t.string :classification
      t.decimal :amount
      t.boolean :taxable

      t.timestamps
    end
  end
end
