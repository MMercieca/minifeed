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
end
