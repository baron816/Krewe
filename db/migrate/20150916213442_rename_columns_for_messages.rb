class RenameColumnsForMessages < ActiveRecord::Migration
  def change
    rename_column :messages, :user_id, :poster_id
    remove_column :messages, :group_id
    add_reference :messages, :messageable, polymorphic: true
  end
end
