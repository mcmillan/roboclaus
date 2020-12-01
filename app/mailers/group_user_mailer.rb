class GroupUserMailer < ApplicationMailer
  def match
    @group_user = params[:group_user]
    @group = @group_user.group
    @user = @group_user.user
    @recipient = @group_user.recipient

    mail(
      to: @user.email,
      subject: '🥁 Your secret santa is...',
      reply_to: "#{@group.slug}@secret.robocla.us"
    )
  end

  def secret_message(message:, context:)
    @group_user = params[:group_user]
    @group = @group_user.group
    @user = @group_user.user
    @recipient = @group_user.recipient
    @context = context
    @message = message

    to = @context == :recipient ? @recipient.email : @user.email
    subject = "🤫 A secret message from your #{@context == :recipient ? 'santa' : 'recipient'}"
    reply_to = @context == :recipient ? "#{@group.slug}+recipient@secret.robocla.us" : "#{@group.slug}@secret.robocla.us"

    mail(
      to: to,
      subject: subject,
      reply_to: reply_to
    )
  end
end
