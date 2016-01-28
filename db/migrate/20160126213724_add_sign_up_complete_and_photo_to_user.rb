class AddSignUpCompleteAndPhotoToUser < ActiveRecord::Migration
  def change
    add_column :users, :sign_up_complete, :boolean, default: false
    add_column :users, :photo_url, :string
  end
end
