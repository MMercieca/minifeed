ActiveAdmin.register KnownFeed do
  permit_params :name, :identifier

  index do
    selectable_column
    id_column
    column :name
    column :identifier
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :identifier
    end
    f.actions
  end
end