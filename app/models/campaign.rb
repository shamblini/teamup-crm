class Campaign < ApplicationRecord
  validates :name, presence: true
  validates :goal_amount, presence: true, numericality: { greater_than: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_date_before_end_date
  
  has_many :donations
  has_many :users, through: :donations

  def total_donations
    donations.sum(:amount)
  end

  def progress
    total_donations.to_f / goal_amount * 100
  end
  
  private
  def start_date_before_end_date
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:start_date, "must be before end date")
    end
  end  

  def status
    if Time.now < start_date
      'Pending'
    elsif Time.now > end_date
      'Expired'
    else
      'Active'
    end
  end
end
