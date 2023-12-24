class LineItem < ApplicationRecord
  CLASSIFICATIONS=%w(income expense filter_columns_for_large_association)

  validate do
    unless CLASSIFICATIONS.include?(classification)
      errors.add(:classification, "Classification must be one of: #{CLASSIFICATIONS.join(', ')}")
    end
  end

  before_save :set_taxable

  def set_taxable
    taxable = false if classification == "expense"
  end
end
