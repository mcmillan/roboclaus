class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  validates :name, presence: true
  validates :address, presence: true

  has_many :group_users
  has_many :groups, through: :group_users
end
