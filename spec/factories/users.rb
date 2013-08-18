FactoryGirl.define do
  factory :user, aliases: [:created_by] do
    sequence(:login)      { |n| "user_#{n}" }
    password              "waffle"
    password_confirmation "waffle"
  #     password_salt: <%= salt = Authlogic::Random.hex_token %>
  #     crypted_password: <%= Authlogic::CryptoProviders::Sha512.encrypt("benrocks" + salt) %>
  #     persistence_token: <%= Authlogic::Random.hex_token %>
  #     single_access_token: <%= Authlogic::Random.friendly_token %>
  #     perishable_token: <%= Authlogic::Random.friendly_token %>

    factory :admin_user do
      after(:build) do |user|
        user.roles << build(:admin_role)
      end
    end
  end
end
