# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_note do
    title       "Note Title"
    content     "Note Content"
    association :client
    association :user
  end
end
