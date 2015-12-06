require "rails_helper"

RSpec.describe GroupMailer, :type => :mailer do
  describe "join_group" do
    before do
      @user = create(:user_home)
      @user2 = create(:user_home)
      @poster = create(:user_wtc)
      @group = @user.groups.first
    end

    let(:mail) { GroupMailer.join_group({group: @group, poster: @poster}) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{@poster.name} joined group #{@group.name}")
      expect(mail.bcc).to eq([@user.email, @user2.email])
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end

  describe "activity_proposal" do
    before do
      @user = create(:user_home)
      @activity = create(:activity_future)
      @group = @user.groups.first
    end

    let(:mail) { GroupMailer.activity_proposal({activity: @activity, group: @group}) }

    it "sends email" do
      expect{ GroupMailer.delay.activity_proposal({activity: @activity, group: @group}) }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("#{@activity.proposer.name} proposed an activity: #{@activity.plan}")
      expect(mail.bcc).to eq([@user.email])
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end
end
