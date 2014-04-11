FactoryGirl.define do
  factory :message do
    sequence(:title) { |n| "Title #{n}" }
    sequence(:content) { |n| "Message #{n}" }
    association :author, factory: :user
  end
end
