class Filter < ApplicationRecord
  belongs_to :segment
  validates :name, :attribute_type, :data, presence: true
end

# attribute type tells whether the filter is for a numerical or categorical attribute of user
# data is a json array of the chosen value for the filter
