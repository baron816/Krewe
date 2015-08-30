require "rails_helper"

RSpec.describe GroupMailer, :type => :mailer do
  describe "join_group" do
    before do
      @user = create(:user_home)
      @poster = create(:user_wtc)
      @group = @user.groups.first
    end

    let(:mail) { GroupMailer.join_group({group: @group, user: @user, poster: @poster}) }

    it "renders the headers" do
      expect(mail.subject).to eq("Krewe: #{@poster.name} joined group #{@group.name}")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["no-reply@kreweapp.com"])
    end

  end

end
