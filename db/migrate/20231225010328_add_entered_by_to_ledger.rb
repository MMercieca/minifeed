class AddEnteredByToLedger < ActiveRecord::Migration[7.0]
  def change
    add_column :line_items, :entered_by, :integer, null: false
  end
end
