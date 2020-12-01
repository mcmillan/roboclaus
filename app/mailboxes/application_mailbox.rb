class ApplicationMailbox < ActionMailbox::Base
  routing /^.*(\+recipient)?@secret.robocla.us$/i => :matches
end
