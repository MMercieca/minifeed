class StockItem < ApplicationRecord
  has_one_attached :image

  CLASSIFICATIONS=%w(bowl bowls nesting-bowls plate plates mug lamp custom)
end
