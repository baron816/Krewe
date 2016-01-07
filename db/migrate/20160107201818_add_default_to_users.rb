class AddDefaultToUsers < ActiveRecord::Migration
  def change
    change_column :users, :category, :string, default: "Doesn't Matter"
  end
end
