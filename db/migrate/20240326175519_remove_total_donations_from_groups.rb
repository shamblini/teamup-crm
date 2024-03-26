class RemoveTotalDonationsFromGroups < ActiveRecord::Migration[7.0]
  def change
    remove_column :groups, :total_donations
  end
end
