class Invitation < ApplicationRecord
  include AASM

  belongs_to :group

  validates :email, presence: true, format: /@/

  validate do
    errors.add(:email, 'is already participating') if group&.users&.exists?(email: email)

    if email_changed? && group&.invitations&.sent&.where('lower(email) = ?', email.downcase)&.any?
      errors.add(:email, 'has already been taken')
    end
  end

  aasm(
    column: :state,
    whiny_persistence: true,
    whiny_transitions: true,
    no_direct_assignment: true
  ) do
    state :sent, default: true
    state :claimed
    state :revoked

    event :claim do
      transitions from: :sent, to: :claimed
    end

    event :revoke do
      transitions from: :sent, to: :revoked
    end
  end

  before_create :generate_token
  after_create :send_invite_email

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(32)
  end

  def send_invite_email
    InvitationMailer.with(invitation: self).invite.deliver_later
  end
end
