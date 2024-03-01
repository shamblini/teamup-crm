class Group < ApplicationRecord
    validates :name, presence: true
    validates :org_type, presence: true
    has_many :users
    def calculate_total_donations
        users.sum { |user| user.calculate_total_donations }
    end
    def calculate_user_count
        users.count()
    end
end
