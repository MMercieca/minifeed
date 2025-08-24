require 'rails_helper'

RSpec.describe MainFeed, type: :model do
  before do
    feed = File.open(Rails.root.join('spec', 'fixtures', 'taz-full.xml')).read
    html = File.open(Rails.root.join('spec', 'fixtures', 'taz.html')).read
    stub_request(:get, 'https://example.com/rss').to_return(status: 200, body: feed)
    stub_request(:get, 'https://www.example.com/rss').to_return(status: 200, body: feed)
    stub_request(:get, 'https://www.example.com/').to_return(status: 200, body: html)
    stub_request(:get, 'https://example.com/').to_return(status: 200, body: "")
    stub_request(:get, "https://image.simplecastcdn.com/images/0838eec6-85d9-4e04-824b-d59d3798a659/b8e75c11-8438-4af7-9c79-c5b4752af8f9/3000x3000/adventure-20zone-20the-20-20season-209-20-20royale.jpg?aid=rss_feed")
         .to_return(status: 200, body: "", headers: {})
  end

  describe '#save' do
    let(:user) { create(:user) }

    it 'sets a unique identifier' do
      main_feed = described_class.create!(user: user, name: 'Test Podcast feed', url: 'https://example.com/rss')

      expect(main_feed.reload.identifier).not_to be_nil
    end
  end

  describe '#create' do
    let(:user) { create(:user) }

    it 'sets a unique identifier' do
      main_feed = described_class.create!(user: user, name: 'Test Podcast feed', url: 'https://example.com/rss')

      expect(main_feed.reload.identifier).not_to be_nil
    end
  end

  describe '#fetch' do
    let(:feed) { create(:main_feed) }
    let(:rss) { File.open(Rails.root.join('spec', 'fixtures', 'taz-full.xml')) }

    before do
      allow(URI).to receive(:open).and_return(rss)
    end

    it 'polls initially' do
      feed.fetch

      expect(URI).to have_received(:open)
    end

    context 'when polled recently' do
      let(:polled_feed) { create(:main_feed, polled_at: 30.minutes.ago, cached_feed: rss.read) }

      it 'does not poll more than once an hour' do
        polled_feed.fetch

        expect(URI).not_to have_received(:open)
      end
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
    it 'is valid if an RSS channel is found' do
      expect(MainFeed.validate_feed_url('https://www.example.com/rss')).to be(true)
    end

    it 'is not valid for HTML' do
      expect(MainFeed.validate_feed_url('https://www.example.com/')).to be(false)
    end

    it 'is false with a web error' do
      expect(MainFeed.validate_feed_url('https://example.com/')).to be(false)
    end
  end
end
