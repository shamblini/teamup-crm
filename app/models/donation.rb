class Donation < ApplicationRecord
  validates :donor_name, presence: true
  validates :amount, presence: true
  validates :donation_date, presence: true
  belongs_to :campaign, optional: true
  # donations not in a campagin can be in a global campain, TODO: add global campaign
end
