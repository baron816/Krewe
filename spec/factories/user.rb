FactoryGirl.define do
	factory :user do
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		sequence(:password) { Faker::Internet.password}

		password_confirmation { password }
	end
end