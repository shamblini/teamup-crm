class Donation < ApplicationRecord
  validates :donor_name, presence: true
  validates :amount, presence: true
  validates :donation_date, presence: true
end
