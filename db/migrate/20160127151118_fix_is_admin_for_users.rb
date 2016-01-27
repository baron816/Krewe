class FixIsAdminForUsers < ActiveRecord::Migration
  def change
    remove_column :users, :is_admin, :boolean
    add_column :users, :is_admin, :boolean, default: false
  end
end
