FactoryGirl.define do
	factory :user do
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password = Faker::Internet.password
		sequence(:password) { password }
		sequence(:password_confirmation) { password }
		sequence(:age) { Faker::Number.number(2)}

		factory :user_home do
			address "135 William Street, New York, NY"
		end

		factory :user_wtc do
			address "1 World Trade Center, New York, NY"
		end

		factory :user_121 do
			address "121 Fulton Street, New York, NY"
		end

		factory :user_dbc do
			address "48 Wall Street, New York, NY"
		end

		factory :user_stucco do
			address '680 St. George Street, Lewisburg, PA'
		end

		factory :user_8th_st do
			address '27 South 8th Street, Lewisburg, PA'
		end

		factory :user_gd do
			address '1130 3rd St, New Orleans, LA'
		end
	end
end