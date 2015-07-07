require "rails_helper"

describe DropUserVote do
  before do
    @user1 = create(:user_home)
    @user2 = create(:user_wtc)
    @user3 = create(:user_121)
    @user4 = create(:user_dbc)
    @group = Group.first
  end

  it "@user doesn't have any drop_user_votes" do
  	expect(@user1.group_drop_votes_count(@group)).to eql(0)
  end

  describe "User#can_vote?" do
    before do
      DropUserVote.create(voter: @user1, user: @user2, group: @group)
    end

    it "doesn't let user vote for itself" do
    	expect(@user1.can_vote?(@user1)).to eql(false)
    end

    it "does let user vote for another voter" do
    	expect(@user1.can_vote?(@user3)).to eql(true)
    end

    it "does not let user vote for another user twice" do
    	expect(@user1.can_vote?(@user2)).to eql(false)
    end
  end

  describe "Group#kick_user" do
    before do
      DropUserVote.create(voter: @user1, user: @user2, group: @group)
      DropUserVote.create(voter: @user3, user: @user2, group: @group)
    end

    it "doesn't kick user after two votes" do
    	@group.kick_user(@user2)
    	expect(@user2.groups).to include(@group)
    end

    it "kicks user after third vote" do
    	DropUserVote.create(voter: @user4, user: @user2, group: @group)
    	@group.kick_user(@user2)
    	expect(@user2.groups).not_to include(@group)
    end
  end
end