class AddAmountAndDonorNameToDonations < ActiveRecord::Migration[7.0]
  def change
    add_column :donations, :amount, :decimal
    add_column :donations, :donor_name, :string
  end
end
