class AddIndexToUserEmail < ActiveRecord::Migration[7.0]
  def change
    # Add column type with unique constraint
    add_index :users, :email, name: "index_users_on_email", unique: true
  end
end
