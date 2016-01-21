require 'rails_helper'

describe DropUserVotesController do
  let(:user1) { create(:user_home) }
  let(:user2) { create(:user_home) }
  let(:group) { Group.first }

  before do
    log_in(user1)
  end

  describe "#POST create" do
    it "creates a drop user vote" do
      expect { post :create, group_id: group, user_id: user2 }.to change(DropUserVote, :count).by(1)
    end
  end
end
