require "rails_helper"

RSpec.describe "FeedController", type: :request do
  let!(:main_feed) { create(:main_feed, url: 'https://example.com/rss') }
  let(:image) { File.open(Rails.root.join('spec', 'fixtures', 'this-is-a-long-title.png')) }
  
  before do
    main_feed.image.attach(io: image, filename: 'test.png')
    feed = File.open(Rails.root.join('spec', 'fixtures', 'taz-full.xml')).read

    stub_request(:get, 'https://example.com/rss').to_return(status: 200, body: feed)
  end

  context 'with ensure_android_auto_compatability set' do
    let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name', ensure_android_auto_compatability: true) }

    it 'removes emojis from the feed title' do
      get "/feeds/#{main_feed.identifier}/#{mini_feed.id}.xml"
      rss = Nokogiri(response.body)

      expect(rss.xpath("//rss/channel/description").text).to eq("Justin, Travis and Griffin McElroy from My Brother, My Brother and Me have recruited their dad Clint for a campaign of high adventure. Join the McElroys as they find their fortune and slay an unconscionable number of ... you know, kobolds or whatever in ... The Adventure Zone..")
    end
  end

  context 'without ensure_android_auto_compatability set' do
    let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name', ensure_android_auto_compatability: false) }

    it 'removes emojis from the feed title' do
      get "/feeds/#{main_feed.identifier}/#{mini_feed.id}.xml"
      rss = Nokogiri(response.body)

      expect(rss.xpath("//rss/channel/description").text).to eq("🔒Justin, Travis and Griffin McElroy from My Brother, My Brother and Me have recruited their dad Clint for a campaign of high adventure. Join the McElroys as they find their fortune and slay an unconscionable number of ... you know, kobolds or whatever in ... The Adventure Zone..")
    end
  end

  context 'with images' do
    let(:mini_feed) { create(:mini_feed, main_feed: main_feed, name: 'Mini Feed Name', ensure_android_auto_compatability: false) }

    it 'uses the public image URL' do
      get "/feeds/#{main_feed.identifier}/#{mini_feed.id}.xml"
      rss = Nokogiri(response.body)

      expect(rss.xpath("//image/url").text.start_with?("https://s3")).to eq(true)
    end
  end
end