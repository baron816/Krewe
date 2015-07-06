class RemoveBirthdayFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :birth_day
  	remove_column :users, :birth_month
  	remove_column :users, :birth_year
  end
end
