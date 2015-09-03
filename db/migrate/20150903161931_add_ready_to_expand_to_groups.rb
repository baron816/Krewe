class AddReadyToExpandToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :ready_to_expand, :boolean, default: false
  end
end
