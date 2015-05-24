class Group < ActiveRecord::Base
	has_many :user_groups
	has_many :users, through: :user_groups
	has_many :messages
	has_many :notifications

	before_create do
		name_group
	end

	def name_group
		self.name = Faker::Commerce.color.capitalize
	end

	def check_space
		self.can_join = self.users.count < self.user_limit
		save
	end

	def drop_user(user)
		users.delete(user)
		check_space
	end

	reverse_geocoded_by :latitude, :longitude
end