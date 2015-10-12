class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :email
      t.string :reasons, array: true

      t.timestamps
    end
  end
end
