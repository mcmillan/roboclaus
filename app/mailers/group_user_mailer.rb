class GroupUserMailer < ApplicationMailer
  def match
    @group_user = params[:group_user]
    @group = @group_user.group
    @user = @group_user.user
    @recipient = @group_user.recipient

    mail(
      to: @user.email,
      subject: '🥁 Your secret santa is...',
      reply_to: "#{@group.slug}@santa.robocla.us"
    )
  end
end
