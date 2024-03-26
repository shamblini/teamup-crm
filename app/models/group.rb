class Group < ApplicationRecord
    validates :name, presence: true
    validates :org_type, presence: true
    has_many :users
    has_many :campaigns
    def calculate_total_donations
        self.total_donations = users.joins(:donations).sum('donations.amount')
    end
end
