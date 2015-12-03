class AddIndexesToNotifications < ActiveRecord::Migration
  def change
    add_index :notifications, :viewed
    add_index :notifications, :notification_type
  end
end
