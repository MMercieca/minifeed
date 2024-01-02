ActiveAdmin.register StockItem do
  permit_params :name, :what, :description, :image, :cost, :price, :location, :sold, :glaze
  menu label: 'Inventory'

  form do |f|
    f.semantic_errors *f.object.errors
    f.inputs do
      f.input :name, input_html: { style: 'width: 50%' } 
      f.input :what, as: :select, collection: StockItem::CLASSIFICATIONS
      f.input :glaze
      f.input :description
      f.input :location
      f.input :price, input_html: { style: 'width: 150px'}
      f.input :sold
    end
    f.actions
  end
end