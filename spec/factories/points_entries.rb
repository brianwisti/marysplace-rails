FactoryGirl.define do
  factory :points_entry do
    association    :client
    association    :added_by, factory: :staff_user
    association    :points_entry_type
    association    :location
    performed_on   Date.today
    points_entered 50
    multiple       1
    points         50
  end
end
