FactoryGirl.define do
	factory :user do
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password = Faker::Internet.password
		sequence(:password) { password }
		sequence(:password_confirmation) { password }
		sequence(:age) { Faker::Number.number(2)}
	end
end