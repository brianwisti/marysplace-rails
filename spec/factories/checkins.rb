FactoryGirl.define do
  factory :checkin do
    association :client
    association :user
    association :location
    checkin_at DateTime.now
  end
end
