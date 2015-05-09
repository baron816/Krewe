class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.references :group
    	t.references :user
    	t.string :content

    	t.timestamps
    end
  end
end
