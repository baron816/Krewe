require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { create(:user_home) }

  describe "password_reset" do
    before do
      user.generate_token(:password_reset_token)
      user.save
    end

    let(:mail) { UserMailer.password_reset(user) }

    it "renders the subject" do
      expect(mail.subject).to eq("Reset Krewe Password")
    end

    it "renders them recipient" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender" do
      expect(mail.from).to eq(["no-reply@gokrewe.com"])
    end
  end

  describe "user_message_alert" do

    context "user wants emails" do
      let!(:user2) { create(:user_home)}
      let!(:user3) { create(:user_wtc) }
      let(:message) { Message.create(messageable: user2, poster: user, content: Faker::Lorem.sentence(5, true, 8)) }
      let(:message2) { Message.create(messageable: user3, poster: user, content: Faker::Lorem.sentence(5, true, 8)) }
      let(:mail) { UserMailer.user_message_alert(message) }
      let(:mail2) { UserMailer.user_message_alert(message2)}

      it "sends email to user in background" do
        expect{ Message.create(messageable: user2, poster: user, content: Faker::Lorem.sentence(5, true, 8)) }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(1)
      end

      it "sends first email with correct headers to user with set notification_settings" do
        expect(mail.subject).to eq("#{user.name} sent you a message")
        expect(mail.to).to eq([user2.email])
        expect(mail.from).to eq(["no-reply@gokrewe.com"])
      end

      it "sends second email with correct headers to user with unset notification_settings" do
        expect(mail2.subject).to eq("#{user.name} sent you a message")
        expect(mail2.to).to eq([user3.email])
        expect(mail2.from).to eq(["no-reply@gokrewe.com"])
      end
    end

    context "user doesnt want emails" do
      let!(:user4) { create(:user_121) }

      it "doesnt sent emails" do
        expect{ Message.create(messageable: user4, poster: user, content: Faker::Lorem.sentence(5, true, 8)) }.to change(Sidekiq::Extensions::DelayedMailer.jobs, :size).by(0)
      end
    end
  end

end
