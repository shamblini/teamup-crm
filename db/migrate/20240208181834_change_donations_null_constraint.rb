class ChangeDonationsNullConstraint < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :donations_id, true
  end
end
