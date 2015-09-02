class CreateExpandGroupVotes < ActiveRecord::Migration
  def change
    create_table :expand_group_votes do |t|
      t.references :voter
      t.references :group

      t.timestamps
    end
  end
end
