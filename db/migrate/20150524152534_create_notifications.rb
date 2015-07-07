class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
    	t.references :notifiable, polymorphic: true
    	t.references :user
    	t.references :poster
    	t.boolean :viewed, default: false

    	t.timestamps
    end
  end
end
