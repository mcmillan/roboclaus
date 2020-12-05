class InvitationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :load_group, except: %i[show]
  before_action :load_invitation, only: %i[destroy]

  def show
    @invitation = Invitation.sent.find_by!(token: params[:id])

    if user_signed_in? && current_user.email == @invitation.email && !@invitation.group.matched?
      @invitation.group.group_users << GroupUser.new(user: current_user)
      @invitation.claim!
      redirect_to @invitation.group, notice: 'Secret santa joined successfully!'
    elsif @invitation.group.matched?
      redirect_to root_path, alert: "That secret santa's already been matched up, so you can't join it."
    elsif user_signed_in?
      redirect_to groups_path, alert: 'The email attached to that invitation does not match your email address.'
    else
      session[:invitation_token] = @invitation.token
      redirect_to new_user_registration_path
    end
  end

  def create
    @invitation = @group.invitations.new(invitation_params)

    if @invitation.save
      redirect_to @group, notice: 'Invitation sent!'
    else
      redirect_to @group, alert: @invitation.errors.full_messages.first
    end
  end

  def destroy
    @invitation.revoke!

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
