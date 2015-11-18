class AddGenderGroupToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :gender_group, :string
    add_index :groups, :gender_group
  end
end
