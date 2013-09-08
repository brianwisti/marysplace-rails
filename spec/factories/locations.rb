# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    sequence(:name)         { |n| "location_#{n}" }
    sequence(:phone_number) { |n| sprintf "206-555-%04d", n }
    sequence(:address)      { |n| sprintf "#{n} Main ST" }
    city "Seattle"
    state "WA"
    postal_code "98101"
  end
end
