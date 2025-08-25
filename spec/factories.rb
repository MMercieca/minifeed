# frozen_string_literal: true

FactoryBot.define do
  factory :mini_feed do
    main_feed { create(:main_feed) }
    after(:build) do |mini_feed|
      mini_feed.image.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'this-is-a-long-title.png')),
        filename: 'logo.png',
        content_type: 'image/png'
      )
    end
  end

  factory :user do
    email { 'podcast-listener@example.com' }
  end

  factory :main_feed do
    user { create(:user) }
    name { 'Test Podcast Feed' }
    url { 'https://www.example.com/rss' }
    after(:build) do |main_feed|
      main_feed.image.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'this-is-a-long-title.png')),
        filename: 'logo.png',
        content_type: 'image/png'
      )
    end
  end
end
