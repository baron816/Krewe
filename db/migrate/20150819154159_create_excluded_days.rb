class CreateExcludedDays < ActiveRecord::Migration
  def change
    create_table :excluded_days do |t|
      t.date :excluded_date
      t.string :times, array: true
      t.references :user
    end
  end
end
