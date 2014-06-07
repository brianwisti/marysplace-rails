# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    sequence(:name) { |n| "organization #{n}" }
    association :creator, factory: :site_admin_user
  end
end
