class CreateExcludedDays < ActiveRecord::Migration
  def change
    create_table :excluded_days do |t|
      t.date :excluded_date
      t.boolean :morning
      t.boolean :afternoon
      t.boolean :evening
      t.references :user
    end
  end
end
