class InvitationsController < ApplicationController
  before_action :load_group

  def show; end

  def create
    @invitation = @group.invitations.new(invitation_params)

    if @invitation.save
      redirect_to @group, notice: 'Invitation sent!'
    else
      redirect_to @group, alert: @invitation.errors.full_messages.first
    end
  end

  private

  def load_group
    @group = Group.find(params[:group_id])
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
