ActiveAdmin.register StockItem do
  permit_params :name, :description, :image, :cost, :price, :location, :sold, :glaze
  menu label: 'Inventory'
end