class Group < ActiveRecord::Base
	has_many :user_groups
	has_many :users, through: :user_groups
	
	before_create do
		find_first_user
		set_coordinates
		get_more_users
	end

	def find_first_user
		self.users << User.find_by(searching: true)
	end

	def set_coordinates
		first_user = self.users.first
		self.longitude = first_user.longitude
		self.latitude = first_user.latitude
	end

	def get_more_users
		if self.users.length < 6
			found_users = User.near(self, 2).where(searching: true).limit(5)
			found_users.each do |user|
				 self.users << user unless self.users.include?(user)
				 user.searching = false
				 user.save! 
			end
		end
	end

	reverse_geocoded_by :latitude, :longitude
end