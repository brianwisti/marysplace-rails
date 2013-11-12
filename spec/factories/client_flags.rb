FactoryGirl.define do
  factory :client_flag do
    can_shop    true
    is_blocking false
    created_by
    client

    factory :bail_flag do
      can_shop false
    end

    factory :resolved_flag do
      resolved_on Date.today
      association :resolved_by, factory: :staff_user
    end
  end
end
