class Internal::WebhooksController < ActionController::API
  def twilio
    blocked = BlockedPhoneNumber.exists?(phone_number: params[:To])

    if blocked && params[:Body].to_s.strip.downcase == 'start'
      BlockedPhoneNumber.where(phone_number: params[:To]).destroy_all

      twiml = Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: '🎅 Welcome back to Roboclaus!'
      end

      return render xml: twiml
    elsif blocked
      twiml = Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: "You've opted out of Roboclaus. Reply START to receive messages from us again."
      end

      return render xml: twiml
    end

    if params[:Body].to_s.strip.downcase == 'stop'
      BlockedPhoneNumber.create(phone_number: params[:To])

      twiml = Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: "You'll no longer be sent any messages by Roboclaus."
      end

      return render xml: twiml
    end

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body: 'No longer feeling the whole Christmas thing? Reply STOP to this message.'
    end

    render xml: twiml
  end
end
