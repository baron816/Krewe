class RemovedUidAndProviderIndexesFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, :uid
    remove_index :users, :provider
  end
end
