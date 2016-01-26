FactoryGirl.define do
  factory :topic do
    name { Faker::Lorem.characters(20) }
    group
  end
end
