FactoryGirl.define do
	factory :user do
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password = Faker::Internet.password
		sequence(:password) { password }
		sequence(:password_confirmation) { password }
		sequence(:age) { Faker::Number.number(2)}

		factory :user_with_group do
			
			ignore do
				group_count 4
			end

			after(:create) do |user, evaluator|
				create_list(:user_group, evaluator.group_count, user: user)
			end
		end
	end
end