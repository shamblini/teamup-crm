class AddDonationDateToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :donation_date, :datetime
  end
end
