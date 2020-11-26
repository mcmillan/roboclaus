class InvitationsController < ApplicationController
  before_action :load_group
  before_action :load_invitation, only: %i[destroy]

  def show; end

  def create
    @invitation = @group.invitations.new(invitation_params)

    if @invitation.save
      redirect_to @group, notice: 'Invitation sent!'
    else
      redirect_to @group, alert: @invitation.errors.full_messages.first
    end
  end

  def destroy
    @invitation.destroy!

    redirect_to @group, notice: "#{@invitation.email} is dead to us now."
  end

  private

  def load_group
    @group = current_user.groups.find(params[:group_id])
  end

  def load_invitation
    @invitation = @group.invitations.find(params[:id])
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
