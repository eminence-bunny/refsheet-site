# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  username        :string
#  email           :string
#  password_digest :string
#  profile         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  has_many :characters
  has_many :transfers_in, class_name: Transfer, foreign_key: :destination_user_id
  has_many :transfers_out, class_name: Transfer, foreign_key: :sender_user_id
  has_one :invitation

  validates :username, presence: true,
            length: { minimum: 3, maximum: 50 },
            format: { with: /\A[a-z0-9][a-z0-9_]+[a-z0-9]\z/i, message: 'no special characters' },
            exclusion: { in: RouteRecognizer.instance.initial_path_segments, message: 'is reserved' },
            uniqueness: { case_sensitive: false }

  validates :email, presence: true,
            format: { with: /@/, message: 'must have @ sign' },
            uniqueness: { case_sensitive: false }

  has_secure_password

  before_validation :downcase_email
  after_create :claim_invitations

  def name
    super || username
  end

  def to_param
    username
  end

  def self.lookup(username)
    Rails.logger.info "Looking up #{username}..."
    u = find_by('LOWER(users.username) = ?', username.downcase)
    Rails.logger.info "Lookup done: #{u.inspect}"
    u
  end

  def self.lookup!(username)
    find_by!('LOWER(users.username) = ?', username.downcase)
  end

  private

  def downcase_email
    self.email.downcase!
  end

  def claim_invitations
    if (invitation = Invitation.find_by('LOWER(invitations.email) = ?', self.email))
      invitation.user = self
      invitation.claim!
      self.invitation = invitation
    end
  end
end
