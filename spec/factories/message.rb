FactoryGirl.define do
  factory :message do
    content { Faker::Lorem.sentence(4) }
    poster 1
    messageable 2
  end
end
