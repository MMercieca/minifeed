FactoryBot.define do
  factory :user do
    email { "podcast-listener@example.com" }
  end

  factory :main_feed do
    user { create(:user) }
    name { 'Test Podcast Feed' }
    url { 'https://example.com/rss' }
  end
end