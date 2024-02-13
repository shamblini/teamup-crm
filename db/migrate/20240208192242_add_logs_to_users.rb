class AddLogsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :logs, null: true, foreign_key: true
  end
end
