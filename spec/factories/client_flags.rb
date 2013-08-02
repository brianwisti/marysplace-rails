FactoryGirl.define do
  factory :client_flag do
    can_shop    true
    is_blocking false
    created_by 
    client
  end
end
