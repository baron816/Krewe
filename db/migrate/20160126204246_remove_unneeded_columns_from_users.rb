class RemoveUnneededColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :sign_in_count
    remove_column :users, :last_sign_in_at
    remove_column :users, :last_sign_in_ip
    remove_column :users, :oauth_token
    remove_column :users, :oauth_expires_at
  end
end
