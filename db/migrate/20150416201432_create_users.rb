class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
    	t.string :password_digest
    	t.string :email
    	t.integer :age
    	t.string :address
    	t.float :latitude
    	t.float :longitude

    	t.timestamps
    end
  end
end
