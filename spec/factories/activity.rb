FactoryGirl.define do
	factory :activity do
		plan { Faker::Lorem.sentence(3) }
		location { Faker::Lorem.sentence(3) }
		longitude { Faker::Address.longitude }
		latitude { Faker::Address.latitude }
		group

		factory :activity_future do
			association :proposer, factory: :user_home
			appointment { Faker::Time.between(DateTime.now, DateTime.now + 8)}
		end

		factory :activity_past do
			association :proposer, factory: :user_home
			appointment { Faker::Time.between(DateTime.now - 1.month, DateTime.now)}
			well_attended true
		end
	end
end
