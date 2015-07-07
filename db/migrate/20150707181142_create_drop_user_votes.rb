class CreateDropUserVotes < ActiveRecord::Migration
  def change
    create_table :drop_user_votes do |t|
    	t.references :user
    	t.references :group
    	t.references :voter

    	t.timestamps
    end
  end
end
