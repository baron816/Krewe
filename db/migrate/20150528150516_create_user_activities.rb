class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
    	t.references :activity
    	t.references :user
    end
  end
end
