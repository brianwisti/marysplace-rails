FactoryGirl.define do
  factory :client do
    sequence(:current_alias) { |n| "client_#{n}" }
    added_by
  end
end
