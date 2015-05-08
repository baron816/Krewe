class User < ActiveRecord::Base
	has_secure_password
	has_many :user_groups
	has_many :groups, through: :user_groups

	geocoded_by :address

	after_validation :geocode

	def address
		[street, city, state].join(',')
	end
end