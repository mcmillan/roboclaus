class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :recipient, optional: true, class_name: 'User'

  validate do
    errors.add(:recipient, 'cannot be self') if user_id.present? && recipient_id.present? && user_id == recipient_id
  end

  before_destroy :ensure_group_not_matched

  private

  def ensure_group_not_matched
    return unless group.matched?

    raise 'group cannot be matched'
  end
end
