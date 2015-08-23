FactoryGirl.define do
  factory :short_url do
    sequence(:url_key) { |n| "ABC#{n}" }
    sequence(:origin_url) { |n| "http:.//google.com/#{n}" }
  end
end