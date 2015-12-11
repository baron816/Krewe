require "rails_helper"

RSpec.describe GroupMailer, :type => :mailer do
  let!(:user) { create(:user_home) }
  let!(:user2) { create(:user_dbc) }
  let!(:user3) { create(:user_121) }
  let!(:poster) { create(:user_wtc) }
  let!(:group) { Group.first }

  describe "join_group" do

    let(:mail) { GroupMailer.join_group({group: group, poster: poster}) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{poster.name} joined group #{group.name}")
      expect(mail.bcc).to include(user.email, user2.email)
      expect(mail.bcc).to_not include(user3.email, poster.email)
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end

  describe "activity_proposal" do
    let!(:activity) { create(:activity_future) }
    before do
      group.activities << activity
    end

    let(:mail) { GroupMailer.activity_proposal(activity) }

    it "sends email" do
      expect{ GroupMailer.delay.activity_proposal(activity) }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("#{activity.proposer.name} proposed an activity: #{activity.plan}")
      expect(mail.bcc).to include(user.email, user2.email)
      expect(mail.bcc).to_not include(user3.email, activity.proposer.email)
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end

  describe "mention_alert" do
    let!(:message) { Message.create(messageable: group.topics.first, poster: poster, content: Faker::Lorem.sentence(5, true, 8))}

    let(:mail) { GroupMailer.mention_alert(message, group.users) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{poster.name} mentioned you in a post")
      expect(mail.bcc).to include(user.email, user2.email)
      expect(mail.bcc).to_not include(poster.email, user3.email)
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end

  describe "expand_group" do
    let(:mail) { GroupMailer.expand_group(group)}

    it "renders the headers" do
      expect(mail.subject).to eq("You have a new group!")
      expect(mail.bcc).to include(user.email, user2.email, poster.email)
      expect(mail.bcc).to_not include(user3.email)
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end
end
