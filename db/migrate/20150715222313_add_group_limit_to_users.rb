class AddGroupLimitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :group_limit, :integer, default: 3
  end
end
