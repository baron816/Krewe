class AddDegreeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :degree, :integer, default: 1
  end
end
