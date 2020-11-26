class Group < ApplicationRecord
  extend FriendlyId
  include AASM

  friendly_id :name, use: %i[slugged finders history]

  has_many :group_users
  has_many :users, through: :group_users
  has_many :invitations

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

    event :match, guards: %i[no_invitations? at_least_two_users?] do
      transitions from: :pending, to: :matched
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

  private

  def perform_matching; end
end
