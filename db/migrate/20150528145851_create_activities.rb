class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
    	t.references :group
    	t.references :proposer
    	t.datetime :appointment
    	t.string :plan

    	t.timestamps
    end
  end
end
