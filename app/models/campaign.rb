class Campaign < ApplicationRecord
  validates :name, presence: true
  validates :goal_amount, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true
end
