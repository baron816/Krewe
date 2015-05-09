class User < ActiveRecord::Base
	has_secure_password
	has_many :user_groups
	has_many :groups, through: :user_groups
	has_many :messages

	geocoded_by :address

	after_validation :geocode

	def address
		[street, city, state].join(', ')
	end

	def birthday
		Date.new(birth_year, birth_month, birth_day)
	end

	def age
		now = Date.today
		now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
	end
end