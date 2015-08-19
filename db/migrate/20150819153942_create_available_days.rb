class CreateAvailableDays < ActiveRecord::Migration
  def change
    create_table :available_days do |t|
      t.integer :day
      t.string :times, array: true
      t.references :user
    end
  end
end
