class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user
  belongs_to :recipient, optional: true, class_name: 'User'

  validate do
    errors.add(:recipient, 'cannot be self') if user&.id == recipient&.id
  end
end
