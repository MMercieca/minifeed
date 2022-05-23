ActiveAdmin.register User do
  permit_params :name, :email, :is_admin

  index do
    selectable_column
    id_column
    column :name
    column :email
    column 'Feeds' do |u|
      u.main_feeds.pluck(:name).join(",")
    end
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :is_admin
    end
    f.actions
  end
end