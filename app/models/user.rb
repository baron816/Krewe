class User < ActiveRecord::Base
	validates :name, presence: true, length: { minimum: 3 }
	validates :email, presence: true, uniqueness: true
	validates :street, presence: true
	validates :city, presence: true
	validates :category, presence: true
	validates :password, presence: true, length: { minimum: 6 }

	has_secure_password
	has_many :user_groups
	has_many :groups, through: :user_groups
	has_many :messages

	after_create do
		find_or_create_group
	end

	geocoded_by :address

	after_validation :geocode

	def find_or_create_group
		group = Group.joins(:users).near(self, 0.5).where(can_join: true, category: self.category).where.not('users.id'=> self.id).take

		unless group.nil?
			self.groups << group
			group.touch
		else
			Group.create(longitude: self.longitude, latitude: self.latitude, category: self.category).users << self
		end
	end

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