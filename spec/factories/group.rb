FactoryGirl.define do
  factory :group do
    name { Faker::Lorem.words }
    longitude { Faker::Address.longitude}
    latitude { Faker::Address.latitude }
    category { GroupNameHelper.constellations.sample }

    factory :old_group do
      can_join false
      created_at { Time.now - 2.months }
    end
  end
end
