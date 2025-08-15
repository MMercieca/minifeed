class AllowForAndroidAutoCompatability < ActiveRecord::Migration[7.0]
  def change
    add_column :mini_feeds, :ensure_android_auto_compatability, :boolean, default: false
    add_column :mini_feeds, :select_all_episodes, :boolean, default: false
  end
end
