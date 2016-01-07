FactoryGirl.define do
  factory :group do
    name { Faker::Lorem.word }

    factory :home_group do
      latitude 40.7094706
      longitude -74.0067142
      category "Professional"
      age_group "22-28"
    end

    factory :old_group do
      longitude { Faker::Address.longitude}
      latitude { Faker::Address.latitude }
      can_join false
      created_at { Time.now - 2.months }
    end
  end
end
