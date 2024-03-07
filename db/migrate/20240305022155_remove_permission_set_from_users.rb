class RemovePermissionSetFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :permission_set, :integer
  end
end
