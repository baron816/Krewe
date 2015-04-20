FactoryGirl.define do

	factory :group do

		factory :group_with_user do
			ignore do
				user_count 3
			end

			after(:create) do |group, evaluator|
				create_list(:user_group, evaluator.user_count, group: group)
			end
		end
	end
end