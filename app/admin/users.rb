ActiveAdmin.register User do
  permit_params :name, :email, :is_admin

  index do
    selectable_column
    id_column
    column :name
    column :email
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