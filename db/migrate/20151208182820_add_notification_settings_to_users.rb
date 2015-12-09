class AddNotificationSettingsToUsers < ActiveRecord::Migration
  enable_extension 'hstore' unless extension_enabled?('hstore')
  def change
    add_column :users, :notification_settings, :hstore, default: {}
  end
end
