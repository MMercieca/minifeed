require 'rails_helper'

RSpec.describe Poster, type: :model do
  describe '#generate' do
    it 'sets the title' do
      expected = Magick::ImageList.new(Rails.root.join('spec', 'fixtures', 'this-is-a-long-title.png'))
      actual = described_class.generate('This is a long title that should wrap')
      
      expect(actual.export_pixels_to_str).to eq(expected.export_pixels_to_str)
    end
  end
end
