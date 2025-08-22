require 'rails_helper'

RSpec.describe MainFeed, type: :model do
  let(:user) { create(:user) }

  describe '#save' do
    it 'sets a unique identifier' do
      main_feed = described_class.new(user: user, name: 'Test Podcast feed', url: 'https://example.com/rss')
      main_feed.save

      expect(main_feed.reload.identifier).not_to be_nil
    end
  end

  describe '#create' do
    it 'sets a unique identifier' do
      main_feed = described_class.create!(user: user, name: 'Test Podcast feed', url: 'https://example.com/rss')

      expect(main_feed.reload.identifier).not_to be_nil
    end
  end

  describe '#fetch' do
    let(:feed) { create(:main_feed) }
    let(:rss) { File.open(Rails.root.join('spec', 'fixtures', 'taz.xml')) }

    before do
      allow(URI).to receive(:open).and_return(rss)
    end

    it 'polls initially' do
      feed.fetch

      expect(URI).to have_received(:open)
    end

    it 'does not poll more than once an hour' do
      feed.update!(polled_at: 30.minutes.ago, cached_feed: rss.read)
      feed.fetch

      expect(URI).not_to have_received(:open)
    end

    it 'always polls when there is no cached feed' do
      feed.update!(polled_at: 30.minutes.ago)
      feed.fetch

      expect(URI).to have_received(:open)
    end

    it 'sets the cached feed' do
      feed.fetch
      
      expect(feed.reload.cached_feed).not_to be_nil
    end

    it 'sets the main feed image' do
      feed.fetch

      expect(feed.image).not_to be_nil
    end
  end

  describe 'self.validate_feed_url' do
    let(:rss) { File.open(Rails.root.join('spec', 'fixtures', 'taz.xml')) }
    let(:html) { File.open(Rails.root.join('spec', 'fixtures', 'taz.html')) }

    it 'is valid if an RSS channel is found' do
      allow(URI).to receive(:open).and_return(rss)
      
      expect(MainFeed.validate_feed_url('https://www.example.com/rss')).to be(true)
    end

    it 'is not valid for HTML' do
      allow(URI).to receive(:open).and_return(html)

      expect(MainFeed.validate_feed_url('https://www.example.com/rss')).to be(false)
    end

    it 'is false with a web error' do
      expect(MainFeed.validate_feed_url('https://www.example.com/rss')).to be(false)
    end
  end
end
