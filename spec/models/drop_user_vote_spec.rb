require "rails_helper"

describe DropUserVote do
  let!(:user1) { create(:user_home) }
  let!(:user2) { create(:user_wtc) }
  let!(:user3) { create(:user_121) }
  let!(:user4) { create(:user_dbc) }
  let(:group) { Group.first }

  it "user doesn't have any drop_user_votes" do
  	expect(DropUserVote.user_vote_count(user1)).to eql(0)
  end

  describe "Group#kick_user" do
    before do
      DropUserVote.create(voter: user1, user: user2, group: group)
      DropUserVote.create(voter: user3, user: user2, group: group)
    end

    it "doesn't kick user after two votes" do
    	expect(group.users).to include(user2)
    end

    it "kicks user after third vote" do
    	DropUserVote.create(voter: user4, user: user2, group: group)
    	expect(group.users).not_to include(user2)
    end
  end
end
