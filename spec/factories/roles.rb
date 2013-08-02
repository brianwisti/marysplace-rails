# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role, :class => 'Roles' do
    sequence(:name) { |n| "role_#{n}" }

    factory :admin_role do
      name "admin"
    end

    factory :staff_role do
      name "staff"
    end

  end
end
