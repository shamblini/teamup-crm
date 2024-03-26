class Group < ApplicationRecord
    validates :name, presence: true
    validates :org_type, presence: true
    has_many :users
    has_many :campaigns
    def calculate_total_donations
        total_donations = 0
        users.each do |user|
            total_donations += user.calculate_total_donations
        end
        total_donations
    end
    def count_donations
        total = 0
        users.each do |user|
            total += user.count_donations
        end
        total
    end
end
