# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MiniFeed, type: :model do
  before do
    feed = File.open(Rails.root.join('spec', 'fixtures', 'taz-full.xml')).read
    stub_request(:get, 'https://www.example.com/rss').to_return(status: 200, body: feed)
    stub_request(:get, 'https://www.example.com/').to_return(status: 200, body: '')
    stub_request(:get, 'https://image.simplecastcdn.com/images/0838eec6-85d9-4e04-824b-d59d3798a659/b8e75c11-8438-4af7-9c79-c5b4752af8f9/3000x3000/adventure-20zone-20the-20-20season-209-20-20royale.jpg?aid=rss_feed')
      .to_return(status: 200, body: '', headers: {})
  end

  describe '#ensure_feed_image' do
    context 'when no image is provided' do
      let(:main_feed) { create(:main_feed) }

      it 'creates a feed image after create' do
        mini_feed = MiniFeed.create!(main_feed: main_feed, name: 'A mini feed')

        expect(mini_feed.image).not_to be_nil
      end
    end

    context 'when an image is provided' do
      let(:image) { File.open(Rails.root.join('spec', 'fixtures', 'this-is-a-long-title.png')) }
      let(:main_feed) { create(:main_feed) }

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
    let(:mini_feed) { create(:mini_feed, name: 'Test', itunes_season: 1) }

    context 'with an iTunes season' do
      it 'does not allow for start_date to be set' do
        mini_feed.update(start_date: Date.yesterday)

        expect(mini_feed.valid?).to eq(false)
      end

      it 'does not allow for end_date to be set' do
        mini_feed.update(end_date: Date.yesterday)

        expect(mini_feed.valid?).to eq(false)
      end

      it 'does not allow words in title to be set' do
        mini_feed.update(episode_prefix: 'Live!')

        expect(mini_feed.valid?).to eq(false)
      end

      it 'does allow an iTunes season to be set when everything else is blank' do
        mini_feed.update(itunes_season: 1)

        expect(mini_feed.valid?).to eq(true)
      end
    end

    context 'with start dates' do
      let(:mini_feed) { create(:mini_feed, name: 'Test', start_date: 1.month.ago) }
      let(:main_feed) { create(:main_feed) }

      it 'saves when only a start date is set' do
        expect(mini_feed.valid?).to eq(true)
      end

      it 'saves when a start date and end date are set' do
        both_dates = MiniFeed.new(main_feed: main_feed, name: 'Test', start_date: 1.month.ago, end_date: Date.yesterday)

        expect(both_dates.valid?).to eq(true)
      end

      it 'does not allow words in the title to be set' do
        mini_feed.update(episode_prefix: 'Live!')

        expect(mini_feed.valid?).to eq(false)
      end
    end
  end

  describe '#episodes' do
    context 'with nothing set' do
      let(:mini_feed) { create(:mini_feed, name: 'Mini Feed Name') }

      it 'returns all of the episodes' do
        expect(mini_feed.episodes.count).to eq(389)
      end
    end

    context 'with iTunes season' do
      let(:mini_feed) { create(:mini_feed, name: 'Mini Feed Name', itunes_season: 1) }

      it 'returns all of the episodes' do
        expect(mini_feed.episodes.count).to eq(92)
      end
    end

    context 'with words in the title' do
      let(:mini_feed) { create(:mini_feed, name: 'Mini Feed Name', episode_prefix: 'Live') }

      it 'returns the episodes with words in the title' do
        expect(mini_feed.episodes.count).to eq(28)
      end
    end

    context 'with a start date' do
      let(:mini_feed) { create(:mini_feed, name: 'Mini Feed Name', start_date: Date.parse('2025-01-01')) }

      it 'returns the episodes after the start date' do
        expect(mini_feed.episodes.count).to eq(29)
      end
    end

    context 'with an end date' do
      let(:mini_feed) { create(:mini_feed, name: 'Mini Feed Name', end_date: Date.parse('2025-01-01')) }

      it 'returns the episodes before the end date' do
        expect(mini_feed.episodes.count).to eq(360)
      end
    end

    context 'with a start date and an end date' do
      let(:mini_feed) do
        create(:mini_feed, name: 'Mini Feed Name', start_date: Date.parse('2024-01-01'),
                           end_date: Date.parse('2025-01-01'))
      end

      it 'returns the episodes between the start and end date' do
        expect(mini_feed.episodes.count).to eq(49)
      end
    end
  end
end
