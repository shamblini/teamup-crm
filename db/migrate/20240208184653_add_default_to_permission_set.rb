class AddDefaultToPermissionSet < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :permission_set, :integer, default: 0
  end
end
