class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
    	t.string :name
    	t.float :longitude
    	t.float :latitude
    	t.timestamps
    end
  end
end
