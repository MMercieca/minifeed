ActiveAdmin.register LineItem do
  permit_params :name, :identifier, :entry_date, :taxable, :amount, :entered_by, :classification
  menu label: 'Ledger'

  config.batch_actions = false

  index do
    selectable_column
    id_column
    column :name
    column :entry_date
    column 'Amount' do |o|
      "<span class='#{o.classification}-style'>#{o.amount}</span>".html_safe
    end
    column :description
    column :classification
    column :taxable
  end

  show do
    div do
      "<span class='action_items'><span class='action_item'><a href='/admin/line_items/new'>New Line Item</a></span></span>".html_safe
    end
    default_main_content
  end

  form do |f|
    f.semantic_errors *f.object.errors
    f.object.taxable = true
    f.object.entry_date = Date.today
    f.inputs do
      f.input :name, input_html: { style: 'width: 50%' } 
      f.input :description
      f.input :source, as: :select, collection: LineItem::SOURCES
      f.input :channel, as: :select, collection: LineItem::CHANNELS
      f.input :classification, as: :select, collection: %w(income expense)
      f.input :entry_date
      f.input :amount, input_html: { style: 'width: 150px'}
      f.input :taxable
    end
    f.input :entered_by, input_html: { value: current_user.id }, as: :hidden
    f.actions
  end
end