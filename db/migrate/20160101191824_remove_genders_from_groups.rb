class RemoveGendersFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :gender_group, :string
  end
end
