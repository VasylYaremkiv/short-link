FactoryGirl.define do
  factory :short_url do
    sequence(:origin_url) { |n| "http:.//google.com/#{n}" }
  end
end