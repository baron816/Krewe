class AddsPasswordDigestAndEmailVerifiedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :email_verified, :boolean, default: false
  end
end
