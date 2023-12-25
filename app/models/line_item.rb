class LineItem < ApplicationRecord
  CLASSIFICATIONS=%w(income expense filter_columns_for_large_association)

  acts_as_paranoid

  scope :income, -> { where(classification: 'income') }
  scope :expense, -> { where(classification: 'expense') }

  validate do
    unless CLASSIFICATIONS.include?(self.classification)
      errors.add(:classification, "Classification must be one of: #{CLASSIFICATIONS.join(', ')}")
    end
  end

  before_create :set_taxable

  def expense?
    classification == 'expense'
  end

  def set_taxable
    self.taxable = false if expense?
  end

  def self.total
    LineItem.income.pluck(:amount).sum - LineItem.expense.pluck(:amount).sum
  end
end
