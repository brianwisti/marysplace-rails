# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    sequence(:name) { |n| "role_#{n}" }

    initialize_with { Role.where(name: name).first_or_create }

    factory :site_admin_role do
      name "site_admin"
    end

    factory :admin_role do
      name "admin"
    end

    factory :staff_role do
      name "staff"
    end

    factory :front_desk_role do
      name "front_desk"
    end
  end
end
