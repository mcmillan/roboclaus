class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@robocla.us', reply_to: 'hohoho@robocla.us'
  layout 'mailer'
end
