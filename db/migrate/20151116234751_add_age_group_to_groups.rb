class AddAgeGroupToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :age_group, :string
    add_index :groups, :age_group
  end
end
