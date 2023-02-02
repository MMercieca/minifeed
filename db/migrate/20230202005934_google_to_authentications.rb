class GoogleToAuthentications < ActiveRecord::Migration[7.0]
  def up
    User.all.each do |user|
      UserAuthentication.create!(
        user_id: user.id,
        uid: user.uid,
        email: user.email,
        provider: "google"
      )
    end
  end
  
  def down
    # no-op
  end
end
