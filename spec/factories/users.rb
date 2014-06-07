FactoryGirl.define do
  factory :user, aliases: [:created_by] do
    sequence(:login)      { |n| "user_#{n}" }
    password              "waffle"
    password_confirmation "waffle"
    email                 { |n| "user_#{n}@example.com" }
  #     password_salt: <%= salt = Authlogic::Random.hex_token %>
  #     crypted_password: <%= Authlogic::CryptoProviders::Sha512.encrypt("benrocks" + salt) %>
  #     persistence_token: <%= Authlogic::Random.hex_token %>
  #     single_access_token: <%= Authlogic::Random.friendly_token %>
  #     perishable_token: <%= Authlogic::Random.friendly_token %>

    factory :site_admin_user do
      after(:build) do |user|
        user.roles << build(:site_admin_role)
      end
    end

    factory :admin_user do
      after(:build) do |user|
        user.roles << build(:admin_role)
      end
    end

    factory :staff_user do
      after(:create) do |user|
        user.roles << create(:staff_role)
      end
    end

    factory :front_desk_user do
      after(:create) do |user|
        user.roles << create(:front_desk_role)
      end
    end
  end
end
