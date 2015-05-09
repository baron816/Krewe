class Group < ActiveRecord::Base
	has_many :user_groups
	has_many :users, through: :user_groups
	has_many :messages

	before_create do
		name_group
	end


	def name_group
		self.name = Faker::Commerce.color.capitalize
	end

	# def get_more_users
	# 	if self.users.length < 6
	# 		found_users = User.near(self, 2).where(searching: true).limit(5)
	# 		found_users.each do |user|
	# 			 self.users << user unless self.users.include?(user) || self.users.length == 6
	# 			 user.searching = false
	# 			 user.save! 
	# 		end
	# 	end
	# end

	reverse_geocoded_by :latitude, :longitude
end