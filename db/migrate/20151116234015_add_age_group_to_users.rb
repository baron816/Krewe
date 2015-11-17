class AddAgeGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age_group, :string
  end
end
