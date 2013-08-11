FactoryGirl.define do
  factory :user, aliases: [:created_by] do
    sequence(:login)      { |n| "user_#{n}" }
    password              "waffle"
    password_confirmation "waffle"
  end
end
