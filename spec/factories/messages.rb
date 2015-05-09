FactoryGirl.define do
	factory :message do
		content { Faker::Lorem.sentence(5, true, 8)}
		association :user, factory: :user_home
		association :group
	end
end