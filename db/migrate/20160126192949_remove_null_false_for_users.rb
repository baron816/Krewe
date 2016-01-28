class RemoveNullFalseForUsers < ActiveRecord::Migration
  def change
    change_column :users, :password_digest, :string, null: true
    change_column :users, :category, :string, null: true
    change_column :users, :is_admin, :string, null: true
  end
end
