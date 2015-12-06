class AddIndexToActivities < ActiveRecord::Migration
  def change
    add_index :activities, :well_attended
    add_index :activities, :appointment
  end
end
