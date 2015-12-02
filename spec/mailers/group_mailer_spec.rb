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
      expect(mail.subject).to eq("#{@poster.name} joined group #{@group.name}")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end

  describe "activity_proposal" do
    before do
      @user = create(:user_home)
      @activity = create(:activity_future)
    end

    let(:mail) { GroupMailer.activity_proposal(@user, @activity) }

    it "sends email" do
      expect{ GroupMailer.delay.activity_proposal(@user, @activity) }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("#{@activity.proposer.name} proposed an activity: #{@activity.plan}")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end
end
