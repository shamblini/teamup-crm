class Group < ApplicationRecord
    validates :name, presence: true
    validates :org_type, presence: true
    has_many :users
end
