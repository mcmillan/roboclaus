class Invitation < ApplicationRecord
  belongs_to :group

  validates :email, presence: true, format: /@/, uniqueness: true

  validate do
    errors.add(:email, 'is already participating') if group&.users&.exists?(email: email)
  end

  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.alphanumeric(32)
  end
end
