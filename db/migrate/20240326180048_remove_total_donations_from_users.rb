class RemoveTotalDonationsFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :total_donations
  end
end
