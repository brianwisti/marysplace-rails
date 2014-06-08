FactoryGirl.define do
  factory :client do
    sequence(:current_alias) { |n| "client_#{n}" }
    association :added_by, factory: :staff_user

    factory :client_with_badge do
      after(:build) do |client|
        client.create_login
      end
    end
  end
end
