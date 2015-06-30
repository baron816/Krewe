FactoryGirl.define do
	factory :activity do
		plan { Faker::Lorem.sentence(3) }
		association :proposer, factory: :user_home
		appointment { Faker::Time.between(DateTime.now, DateTime.now + 8)}
	end
end