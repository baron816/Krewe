class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.references :group
    	t.references :user
    	t.references :poster
    	t.boolean :viewed, default: false
    	t.string :category

    	t.timestamps
    end
  end
end
