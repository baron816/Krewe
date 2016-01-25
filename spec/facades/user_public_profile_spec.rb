require "rails_helper"

describe UserPublicProfile do
  let(:user1){ create(:user_home) }
  let(:user2){ create(:user_home) }

  describe "#personal_messages" do
    before do
      create_list(:message, 4, poster: user1, messageable: user2)
      create_list(:message, 4, poster: user1, messageable: user2)
    end
    let(:public_profile) { UserPublicProfile.new(user1, user2, 1) }

    it "returns the messages" do
      expect(public_profile.personal_messages.count).to eq(8)
    end
  end
end
