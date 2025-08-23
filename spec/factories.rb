FactoryBot.define do
  factory :mini_feed do
    
  end

  factory :user do
    email { "podcast-listener@example.com" }
  end

  factory :main_feed do
    user { create(:user) }
    name { 'Test Podcast Feed' }
    url { 'https://example.com/rss' }
  end
end