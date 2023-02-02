class RemoveUniqueEmailIndex < ActiveRecord::Migration[7.0]
  def up
    remove_index :users, :email
    add_index :users, :email, unique: false
  end

  def down
    # we won't do this
  end
end
