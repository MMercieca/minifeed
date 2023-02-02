class CreateUserAuthentications < ActiveRecord::Migration[7.0]
  def change
    create_table :user_authentications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :email

      t.timestamps
    end
  end
end
