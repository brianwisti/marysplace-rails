FactoryGirl.define do
  factory :message do
    sequence(:content) { |n| "Message #{n}" }
    association :author, factory: :user
  end
end
