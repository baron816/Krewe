FactoryGirl.define do
	factory :user do
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password 'foobar'
		password_confirmation 'foobar'
	end
end