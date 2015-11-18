class AddGenderGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender_group, :string
  end
end
