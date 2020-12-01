class MatchesMailbox < ApplicationMailbox
  def process
    GroupUserMailer.with(group_user: group_user)
                   .secret_message(context: context, message: message)
                   .deliver_later
  end

  private

  def message
    text = mail.multipart? && mail.text_part ? mail.text_part.decoded : mail.decoded

    EmailReplyParser.parse_reply(text)
  end

  def group_user
    @group_user ||= group.group_users.includes(:user).find_by!(users: { email: mail.from })
  end

  def group
    @group ||= Group.find(group_slug)
  end

  def group_slug
    @group_slug ||= to_address.split('@').first.sub('+recipient', '')
  end

  def context
    to_address.include?('+recipient@') ? :santa : :recipient
  end

  def to_address
    @to_address = mail.to.detect do |address|
      address.include?('secret.robocla.us')
    end
  end
end
