ActiveAdmin.register LineItem do
  permit_params :name, :identifier, :entry_date, :taxable, :amount
  menu label: 'Ledger'

  index do
    selectable_column
    id_column
    column :identifier
    column :name
    column :entry_date
    column :amount
    column :taxable
    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors
    f.object.taxable = true
    f.object.entry_date = Date.today
    f.inputs do
      f.input :name
      f.input :classification, as: :select, collection: %w(income expense)
      f.input :entry_date
      f.input :amount
      f.input :taxable
    end
    f.actions
  end
end