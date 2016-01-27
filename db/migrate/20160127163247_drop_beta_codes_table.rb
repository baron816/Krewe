class DropBetaCodesTable < ActiveRecord::Migration
  def change
    drop_table :beta_codes
  end
end
