class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  validates :name, presence: true
  validates :address, presence: true

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  attr_accessor :invitation

  after_create do
    invitation&.destroy!
  end

  def self.new_with_session(params, session)
    new(params).tap do |user|
      next unless session[:invitation_token]

      invitation = Invitation.find_by(token: session[:invitation_token])

      next unless invitation
      next if invitation.group.matched?

      user.invitation = invitation
      user.email = params[:email] || invitation.email
      user.group_users << user.group_users.new(group: invitation.group)
    end
  end
end
