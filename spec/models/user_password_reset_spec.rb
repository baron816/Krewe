require 'rails_helper'

describe UserPasswordReset do
  let(:user) { build(:user_home) }

  describe "#send_password_reset" do
    it "starts without a password reset token" do
      expect(user.password_reset_token).to be_nil
    end

    it "has a token once set" do
      UserPasswordReset.new(user).send_password_reset
      expect(user.password_reset_token).not_to be_nil
    end

    it "sets the password reset sent at time" do
      UserPasswordReset.new(user).send_password_reset
      expect(user.password_reset_sent_at).to be_a(Time)
    end
  end

  describe "#password_reset_expired?" do
    it "has not expired" do
      UserPasswordReset.new(user).send_password_reset
      expect(UserPasswordReset.new(user).password_reset_expired?).to eq(false)
    end

    it "can be expired" do
      UserPasswordReset.new(user, Time.zone.now - 2.hours).send_password_reset
      expect(UserPasswordReset.new(user).password_reset_expired?).to eq(true)
    end
  end
end
