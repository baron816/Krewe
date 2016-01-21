class DropUserVote < ActiveRecord::Base
	belongs_to :user
	belongs_to :voter, class_name: 'User'
	belongs_to :group

	validates_presence_of :user, :group, :voter

	after_create :kick_user

	scope :user_vote_count, -> (user){ where(user_id: user).count }

	def self.voter_vote(voter)
	  find_by(voter_id: voter)
	end

	def kick_user
		DropUser.new(group, user).drop if DropUserVote.user_vote_count(user) >= 3
	end
end
