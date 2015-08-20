class CreateAvailableDays < ActiveRecord::Migration
  def change
    create_table :available_days do |t|
      t.integer :day
      t.boolean :morning
      t.boolean :afternoon
      t.boolean :evening
      t.references :user
    end
  end
end
