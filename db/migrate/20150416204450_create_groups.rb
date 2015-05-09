class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
    	t.string :name
    	t.float :longitude
    	t.float :latitude
    	t.integer :user_limit, default: 6
    	t.boolean :can_join, default: true
    	t.timestamps
    end
  end
end
