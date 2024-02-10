class AddGroupIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :group, foreign_key: true, default: 1
  end
end
