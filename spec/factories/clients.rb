FactoryGirl.define do
  factory :client do
    sequence(:current_alias) { |n| "client_#{n}" }
    association :added_by, factory: :user
  end
end
