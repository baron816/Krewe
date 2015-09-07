class AddHasExpandedToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :has_expanded, :boolean, default: false
  end
end
