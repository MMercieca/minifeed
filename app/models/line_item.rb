# Why is there a ledger in a RSS splitting app?
#
# I needed one for a different project but I only have one web site.  So,
# much like the business world, the app grew a bit in unexpected ways.
class LineItem < ApplicationRecord
  CLASSIFICATIONS=%w(income expense filter_columns_for_large_association)
  SOURCES=%w(shopify etsy market)
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
