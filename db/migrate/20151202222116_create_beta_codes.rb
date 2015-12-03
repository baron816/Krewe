class CreateBetaCodes < ActiveRecord::Migration
  def change
    create_table :beta_codes do |t|
      t.string :auth_token, index: true
      t.string :email
      t.boolean :used, default: false
    end
  end
end
