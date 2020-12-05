class Internal::WebhooksController < ActionController::API
  def twilio
    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body: 'To opt out, please email hohoho@robocla.us'
    end

    render xml: twiml
  end
end
