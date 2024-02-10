class User < ApplicationRecord
  belongs_to :donations, class_name: 'Donation', optional: true
  belongs_to :logs, class_name: 'Log', optional: true
  belongs_to :group
  delegate :name, to: :group, prefix: true, allow_nil: true
end
