class AddDropedGroupsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :dropped_group_ids, :integer, array: true, default: []
  end
end
