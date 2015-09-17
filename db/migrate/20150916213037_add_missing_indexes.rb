class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :notifications, :user_id
    add_index :messages, :user_id
    add_index :messages, :group_id
    add_index :user_groups, :user_id
    add_index :user_groups, :group_id
    add_index :user_groups, [:group_id, :user_id]
    add_index :user_activities, :user_id
    add_index :user_activities, :activity_id
    add_index :user_activities, [:activity_id, :user_id]
    add_index :personal_messages, :sender_id
    add_index :personal_messages, :receiver_id
    add_index :expand_group_votes, :voter_id
    add_index :expand_group_votes, :group_id
    add_index :drop_user_votes, :user_id
    add_index :drop_user_votes, :voter_id
    add_index :drop_user_votes, :group_id
    add_index :activities, :group_id
    add_index :activities, :proposer_id
  end
end
