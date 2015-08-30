require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "password_reset" do
    before do
      @user = create(:user_home)
      @user.generate_token(:password_reset_token)
      @user.save
    end

    let(:mail) { UserMailer.password_reset(@user) }

    it "renders the subject" do
      expect(mail.subject).to eq("Reset Krewe Password")
    end

    it "renders them recipient" do
      expect(mail.to).to eq([@user.email])
    end

    it "renders the sender" do
      expect(mail.from).to eq(["no-reply@kreweapp.com"])
    end
  end

end
