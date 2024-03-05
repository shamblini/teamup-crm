class Group < ApplicationRecord
    validates :name, presence: true
    validates :org_type, presence: true
    has_many :users
    def calculate_total_donations
        self.total_donations = users.joins(:donations).sum('donations.amount')
        save
    end
end
