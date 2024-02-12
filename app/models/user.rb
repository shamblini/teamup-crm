class User < ApplicationRecord
  belongs_to :donations, class_name: 'Donation', optional: true
  belongs_to :logs, class_name: 'Log', optional: true
  USER_CREATE = 1
  USER_READ = 2
  USER_UPDATE = 4
  USER_DELETE = 8
end
