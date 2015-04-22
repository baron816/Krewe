class Group < ActiveRecord::Base
	has_many :user_groups
	has_many :users, through: :user_groups
	
	before_create do
		find_first_user
		set_coordinates
	end

	def find_first_user
		self.users << User.find_by(searching: true)
	end

	def set_coordinates
		first_user = self.users.first
		self.longitude = first_user.longitude
		self.latitude = first_user.latitude
	end

end