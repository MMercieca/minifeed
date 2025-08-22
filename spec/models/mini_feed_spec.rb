require 'rails_helper'

RSpec.describe MiniFeed, type: :model do
  let(:main_feed) { create(:main_feed) }

  describe '#ensure_feed_image' do
    context 'when no image is provided' do
      it 'creates a feed image after create' do
        mini_feed = MiniFeed.create!(main_feed: main_feed, name: 'A mini feed')

        expect(mini_feed.image).not_to be_nil
      end
    end

    context 'when an image is provided' do
      let(:image) { File.open(Rails.root.join('spec', 'fixtures', 'this-is-a-long-title.png')) }

      before do
        allow(Poster).to receive(:generate)
      end

      it 'does not create a feed image' do
        mini_feed = MiniFeed.new(main_feed: main_feed, name: 'A mini feed')
        mini_feed.image.attach(io: image, filename: 'test.png')
        mini_feed.save
        
        expect(Poster).not_to have_received(:generate)
      end
    end
  end
end
