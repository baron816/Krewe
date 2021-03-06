class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name, null: false
    	t.string :password_digest, null: false
    	t.string :email, null: false
    	t.string :street, null: false
        t.string :city, null: false
        t.string :state, null: false
        t.string :category, null: false
    	t.float :latitude
    	t.float :longitude

    	t.timestamps
    end
  end
end
