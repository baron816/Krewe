FactoryGirl.define do
	factory :user do
		sequence(:name) { Faker::Name.name }
		sequence(:email) { Faker::Internet.email }
		password = '123456'
		sequence(:password) { password }
		sequence(:password_confirmation) { password }

		factory :post_grads do
			category 'Post-Grad'

			factory :user_home do
				street "135 William Street"
				city 'New York'
				state 'NY'
				longitude -74.00671419999999
				latitude 40.7094706
			end

			factory :user_wtc do
				street "1 World Trade Center"
				city "New York"
				state "NY"
				longitude -74.0133032
				latitude 40.7129086
			end

			factory :user_121 do
				street "121 Fulton Street"
				city "New York"
				state "NY"
				longitude -74.0070554
				latitude 40.7100732
			end

			factory :user_dbc do
				street "48 Wall Street"
				city "New York"
				state "NY"
				latitude 40.7063634
				longitude -74.0090963
			end

			factory :user_138 do
				street "138 William Street"
				city "New York"
				state "NY"
				latitude 40.7103407
				longitude -74.0083273
			end

			factory :user_122 do
				street "122 Fulton St"
				city "New York"
				state "NY"
				latitude 40.7099729
				longitude -74.0076159
			end

			factory :user_130 do
				street "130 Fulon st"
				city "New York"
				state "NY"
				latitude 40.7103049
				longitude -74.0080866
			end

			factory :user_134 do
				street '134 Fulton St'
				city "New York"
				state "NY"
				latitude 40.7102972
				longitude -74.0083025
			end

			factory :user_stucco do
				street '680 St. George Street'
				city 'Lewisburg'
				state 'PA'
				latitude 40.9589662
				longitude -76.8862625
			end

			factory :user_8th_st do
				street '27 South 8th Street'
				city 'Lewisburg'
				state 'PA'
				latitude 40.960504
				longitude -76.890044
			end

			factory :user_gd do
				street '1130 3rd St'
				city 'New Orleans'
				state 'LA'
				latitude 29.927595
				longitude -90.0814989
			end
		end
	end
end
