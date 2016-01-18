class ExpandGroupVote < ActiveRecord::Base
  belongs_to :voter, class_name: "User"
  belongs_to :group

  delegate :users_include?, to: :group, prefix: true

  validates_presence_of :voter, :group

  def self.user_votes(user)
    find_by(voter_id: user)
  end
end
