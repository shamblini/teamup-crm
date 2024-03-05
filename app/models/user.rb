class User < ApplicationRecord
  belongs_to :donations, class_name: 'Donation', optional: true
  belongs_to :logs, class_name: 'Log', optional: true
  belongs_to :group
  delegate :name, to: :group, prefix: true, allow_nil: true

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    # return nil unless email =~ /@mybusiness.com\z/
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
  end
end
