class Group < ActiveRecord::Base
	has_many :user_groups
	has_many :users, through: :user_groups
	has_many :messages

	before_create do
		name_group
	end

	after_touch do
		check_space
		save
	end

	def name_group
		self.name = Faker::Commerce.color.capitalize
	end

	def check_space
		self.can_join = self.users.count < self.user_limit
	end

	reverse_geocoded_by :latitude, :longitude
end