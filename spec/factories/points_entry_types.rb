FactoryGirl.define do
  factory :points_entry_type do
    sequence(:name) { |n| "entry_type_#{n}" }
    is_active       true
    default_points  0
  end

  factory :chore_entry_type do
    sequence(:name) { |n| "chore_#{n}" }
    default_points  50
  end
end
