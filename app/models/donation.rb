class Donation < ApplicationRecord
  validates :donor_name, presence: true
  validates :amount, presence: true
  validates :donation_date, presence: true
  belongs_to :campaign, optional: true
  delegate :name, to: :campaign, prefix: true, allow_nil: true
  belongs_to :user, optional: true
  
end
