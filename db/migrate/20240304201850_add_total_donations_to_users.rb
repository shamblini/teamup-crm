class AddTotalDonationsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :total_donations, :decimal, default: 0.0
  end
end
