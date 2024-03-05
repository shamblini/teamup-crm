class AddUserIdToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :user_id, :integer
  end
end
