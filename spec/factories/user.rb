FactoryGirl.define do
	factory :user do
		age_group "65+"
		after(:create) { |user| user.send(:find_group) }
		sign_up_complete true

		trait :admin do
			is_admin true
		end

		factory :email_provider do
			category "Creative"
			address "135 William Street, New York, NY"
			longitude -74.00671419999999
			latitude 40.7094706
			name { Faker::Name.name }
			email { Faker::Internet.email }
		end

		factory :facebook_provider do
			uid '12345'
			provider 'facebook'
			password "msb295ns()*"

			factory :baron do
				category "Blue Collar"
				name "Baron Willeford"
				email "baron@mail.com"
				address "135 William Street, New York, NY"
				longitude -74.00671419999999
				latitude 40.7094706
			end


			factory :professionals do
				category 'Professional'
				name { Faker::Name.name }
				email { Faker::Internet.email }

				factory :user_home do
					address "135 William Street, New York, NY"
					longitude -74.00671419999999
					latitude 40.7094706
					notification_settings {{'join' => 'true', 'proposal' => 'true', 'personal' => 'true', 'mention' => 'true', 'expand' => 'true'}}
				end

				factory :user_wtc do
					address "1 World Trade Center, New York, NY"
					longitude -74.0133032
					latitude 40.7129086
				end

				factory :user_121 do
					address "121 Fulton Street, New York, NY"
					longitude -74.0070554
					latitude 40.7100732
					notification_settings {{"join" => "false", "proposal" => 'false', "personal" => "false", 'mention' => 'false', 'expand' => 'false'}}
				end

				factory :user_dbc do
					address "48 Wall Street, New York, NY"
					latitude 40.7063634
					longitude -74.0090963
				end

				factory :user_138 do
					address "138 William Street, New York, NY"
					latitude 40.7103407
					longitude -74.0083273
				end

				factory :user_122 do
					address "122 Fulton St, New York, NY"
					latitude 40.7099729
					longitude -74.0076159
				end

				factory :user_130 do
					address "130 Fulon st, New York, NY"
					latitude 40.7103049
					longitude -74.0080866
				end

				factory :user_134 do
					address '134 Fulton St, New York, NY'
					latitude 40.7102972
					longitude -74.0083025
				end

				factory :user_stucco do
					address '680 St. George Street, Lewisburg, PA'
					latitude 40.9589662
					longitude -76.8862625
				end

				factory :user_8th_st do
					address '27 South 8th Street, Lewisburg, PA'
					latitude 40.960504
					longitude -76.890044
				end

				factory :user_gd do
					address '1130 3rd St, New Orleans, LA'
					latitude 29.927595
					longitude -90.0814989
				end
			end
		end
	end
end
