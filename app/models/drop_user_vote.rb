class DropUserVote < ActiveRecord::Base
	belongs_to :user
	belongs_to :voter, class_name: 'User'
	belongs_to :group

	validates_presence_of :user, :group, :voter

	scope :user_votes, -> (user){ where(user_id: user) }
	scope :group_votes, -> (group){ where(group_id: group) }
	scope :voter_votes, -> (voter){ where(voter_id: voter)}
end
