class AddIndexesToGroups < ActiveRecord::Migration
  def change
    add_index :groups, :can_join
    add_index :groups, :category
    add_index :groups, :degree
    add_index :groups, :latitude
    add_index :groups, :longitude
  end
end
