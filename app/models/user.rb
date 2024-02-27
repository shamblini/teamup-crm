class User < ApplicationRecord
  belongs_to :donations, class_name: 'Donation', optional: true
  belongs_to :logs, class_name: 'Log', optional: true
  belongs_to :group
  delegate :name, to: :group, prefix: true, allow_nil: true
  USER_CREATE = 1
  USER_READ = 2
  USER_UPDATE = 4
  USER_DELETE = 8
  DONATION_CREATE = 16
  DONATION_READ = 32
  DONATION_UPDATE = 64
  DONATION_DELETE = 128
  CAMPAIGN_CREATE = 256
  CAMPAIGN_UPDATE = 512
  CAMPAIGN_DELETE = 1024

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    # return nil unless email =~ /@mybusiness.com\z/
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
  end
end
