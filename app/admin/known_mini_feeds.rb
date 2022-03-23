ActiveAdmin.register KnownMiniFeed do
  # create_table "known_mini_feeds", force: :cascade do |t|
  #   t.bigint "known_feed_id", null: false
  #   t.string "episodes_identifier"
  #   t.string "feed_name"
  #   t.datetime "created_at", null: false
  #   t.datetime "updated_at", null: false
  #   t.index ["known_feed_id"], name: "index_known_mini_feeds_on_known_feed_id"
  # end
  permit_params :known_feed_id, :feed_name, :episodes_identifier, :image

  index do
    selectable_column
    id_column
    column :known_feed
    column :episode_prefix
    column :feed_name
    column :image do |i|
      if i.image.attached?
        "<img width='100' src='#{url_for(i.image.url)}' />".html_safe
      end
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :known_feed
      f.input :feed_name
      f.input :episode_prefix
      f.input :image, as: :file
    end
    f.actions
  end
end