class InvitationMailer < ApplicationMailer
  def invite
    @invitation = params[:invitation]

    mail(
      to: @invitation.email,
      subject: "🎅 You're invited to join #{@invitation.group.name}'s secret santa"
    )
  end
end
