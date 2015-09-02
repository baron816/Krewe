class AddWellAttendedToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :well_attended, :boolean, default: false
  end
end
