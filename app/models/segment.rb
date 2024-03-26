class Segment < ApplicationRecord
  validates :name, presence: true
  has_many :filters
  has_many :users

  def initialize_with_filters(filters_data)
    filters_data.each do |filter_data|
      filters.build(
        name: filter_data[0],
        attribute_type: filter_data[1],
        data: filter_data[2]
      )
    end
  end
end
