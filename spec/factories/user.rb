FactoryGirl.define do
	factory :user do
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password = Faker::Internet.password
		sequence(:password) { password }
		sequence(:password_confirmation) { password }

		factory :post_grads do 
			category 'Post-Grad'

			factory :user_home do
				street "135 William Street"
				city 'New York'
				state 'NY'
			end

			factory :user_wtc do
				street "1 World Trade Center"
				city "New York"
				state "NY"
			end

			factory :user_121 do
				street "121 Fulton Street"
				city "New York"
				state "NY"
			end

			factory :user_dbc do
				street "48 Wall Street"
				city "New York"
				state "NY"
			end

			factory :user_138 do
				street "138 William Street"
				city "New York"
				state "NY"
			end

			factory :user_122 do
				street "122 Fulton St"
				city "New York"
				state "NY"
			end

			factory :user_130 do
				street "130 Fulon st"
				city "New York"
				state "NY"
			end

			factory :user_134 do
				street '134 Fulton St'
				city "New York"
				state "NY"
			end

			factory :user_stucco do
				street '680 St. George Street'
				city 'Lewisburg'
				state 'PA'
			end

			factory :user_8th_st do
				street '27 South 8th Street'
				city 'Lewisburg'
				state 'PA'
			end

			factory :user_gd do
				street '1130 3rd St'
				city 'New Orleans'
				state 'LA'
			end
		end
	end
end