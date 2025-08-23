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

  describe '#validations' do
    context 'with an iTunes season' do
      it 'does not allow for start_date to be set' do
        mini_feed = described_class.new(name: 'Test', main_feed: main_feed, itunes_season: 1, start_date: Date.yesterday)
        mini_feed.save

        expect(mini_feed.valid?).to eq(false)
      end

      it 'does not allow for end_date to be set' do
        mini_feed = described_class.new(name: 'Test', main_feed: main_feed, itunes_season: 1, end_date: Date.yesterday)
        mini_feed.save

        expect(mini_feed.valid?).to eq(false)
      end

      it 'does not allow words in title to be set' do
        mini_feed = described_class.new(name: 'Test', main_feed: main_feed, itunes_season: 1, episode_prefix: 'Live!')
        mini_feed.save

        expect(mini_feed.valid?).to eq(false)
      end

      it 'does allow an iTunes season to be set when everything else is blank' do
        mini_feed = described_class.new(name: 'Test', main_feed: main_feed, itunes_season: 1)
        mini_feed.save

        expect(mini_feed.valid?).to eq(true)
      end
    end

    context 'with start dates' do
      it 'saves when only a start date is set' do
        mini_feed = described_class.new(name: 'Test', main_feed: main_feed, start_date: Date.yesterday)
        mini_feed.save

        expect(mini_feed.valid?).to eq(true)
      end

      it 'saves when a start date and end date are set' do
        mini_feed = described_class.new(name: 'Test', main_feed: main_feed, start_date: 1.week.ago, end_date: Date.yesterday)
        mini_feed.save

        expect(mini_feed.valid?).to eq(true)
      end
    end
  end

  describe '#episodes' do
    let!(:rss_file) { File.open(Rails.root.join('spec', 'fixtures', 'taz-full.xml')) }
    let!(:rss_feed) { Nokogiri(rss_file) }

    before do
      allow(main_feed).to receive(:fetch).and_return(rss_feed)
    end

    context 'with nothing set' do
      let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name') }

      it 'returns all of the episodes' do
        expect(mini_feed.episodes.count).to eq(389)
      end
    end

    context 'with iTunes season' do
      let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name', itunes_season: 1) }

      it 'returns all of the episodes' do
        expect(mini_feed.episodes.count).to eq(92)
      end
    end

    context 'with words in the title' do
      let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name', episode_prefix: "Live") }

      it 'returns the episodes with words in the title' do
        expect(mini_feed.episodes.count).to eq(28)
      end
    end

    context 'with a start date' do
      let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name', start_date: Date.parse("2025-01-01")) }

      it 'returns the episodes after the start date' do
        expect(mini_feed.episodes.count).to eq(29)
      end
    end

    context 'with an end date' do
      let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name', end_date: Date.parse("2025-01-01")) }

      it 'returns the episodes before the end date' do
        expect(mini_feed.episodes.count).to eq(360)
      end
    end

    context 'with a start date and an end date' do
      let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name', start_date: Date.parse("2024-01-01"), end_date: Date.parse("2025-01-01")) }

      it 'returns the episodes between the start and end date' do
        expect(mini_feed.episodes.count).to eq(49)
      end
    end
  end
end
