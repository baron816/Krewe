class CreatePersonalMessages < ActiveRecord::Migration
  def change
    create_table :personal_messages do |t|
    	t.references :sender
    	t.references :receiver
    	t.string :content

    	t.timestamps
    end
  end
end
