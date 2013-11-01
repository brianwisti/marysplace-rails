FactoryGirl.define do
  factory :points_entry do
    association  :client
    association  :added_by, factory: :staff_user
    association  :points_entry_type
    association  :location
    performed_on Date.today
    points       50
  end
end
