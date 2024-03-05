class MakeUserIndexesOptional < ActiveRecord::Migration[7.0]
  def change
    remove_index :users, name: "index_users_on_group_id" if index_exists?(:users, :group_id)
    remove_index :users, name: "index_users_on_logs_id" if index_exists?(:users, :logs_id)

    add_index :users, :group_id, name: "index_users_on_group_id" if column_exists?(:users, :group_id)
    add_index :users, :logs_id, name: "index_users_on_logs_id" if column_exists?(:users, :logs_id)
  end
end
