class ApplicationMailer < ActionMailer::Base
  default from: 'Roboclaus <no-reply@robocla.us>', reply_to: 'hohoho@robocla.us'
  layout 'mailer'
end
