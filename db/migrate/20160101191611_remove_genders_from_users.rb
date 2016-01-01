class RemoveGendersFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :gender_group, :string
  end
end
