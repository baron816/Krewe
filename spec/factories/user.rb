FactoryGirl.define do
	factory :user do
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password = Faker::Internet.password
		sequence(:password) { password }
		sequence(:password_confirmation) { password }
		sequence(:age) { Faker::Number.number(2)}

		factory :user_with_group do
			

			after(:create) do |user, evaluator|
				create_list(:user_group, 4, user: user)
			end
		end
	end
end