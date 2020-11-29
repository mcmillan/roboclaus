class Group < ApplicationRecord
  extend FriendlyId
  include AASM

  friendly_id :name, use: %i[slugged finders history]

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :invitations, dependent: :destroy

  validates :name, presence: true
  validates :budget, presence: true
  validates :deadline, presence: true
  validate do
    errors.add(:deadline, 'must be in the future') if deadline.present? && deadline < Date.today
    errors.add(:deadline, 'must be before Christmas') if deadline.present? && deadline >= Date.new(2020, 12, 25)
  end

  aasm(
    column: :state,
    whiny_persistence: true,
    whiny_transitions: true,
    no_direct_assignment: true
  ) do
    state :pending, initial: true
    state :matched

    event :match, guards: %i[no_invitations? at_least_two_users?], before: :perform_matching do
      transitions from: :pending, to: :matched
    end

    event :unmatch, before: :perform_unmatching do
      transitions from: :matched, to: :pending
    end
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def no_invitations?
    invitations.none?
  end

  def at_least_two_users?
    users.count >= 2
  end

  def recipient_for(user)
    group_users.find_by(user: user).recipient
  end

  private

  def perform_matching
    transaction do
      candidates = users.shuffle

      group_users.each do |group_user|
        recipient = candidates.excluding(group_user.user).sample
        group_user.update!(recipient: recipient)
        candidates.delete(recipient)
      end

      raise 'not all candidates matched' if candidates.any?
    end
  end

  def perform_unmatching
    group_users.update_all(recipient_id: nil)
  end
end
