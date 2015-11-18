class AddMoreMissingIndexes < ActiveRecord::Migration
  def change
    add_index :messages, ["messageable_id", "messageable_type"]
    add_index :topics, :group_id
    add_index :notifications, ["notifiable_id", "notifiable_type"]
    add_index :notifications, :notifiable_id
    add_index :notifications, :poster_id
  end
end
