class ChangeGroupLimitDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :users, :group_limit, 1
  end
end
