class Internal::WebhooksController < ActionController::API
  def twilio
    blocked = BlockedPhoneNumber.exists?(phone_number: params[:From])
    body = params[:Body].to_s.strip.downcase

    if blocked && body == 'start'
      BlockedPhoneNumber.where(phone_number: params[:From]).destroy_all

      twiml = Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: '🎅 Welcome back to Roboclaus!'
      end

      return render xml: twiml
    elsif blocked
      twiml = Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: "❌ You've opted out of Roboclaus. Reply START to receive messages from us again."
      end

      return render xml: twiml
    elsif body == 'stop'
      BlockedPhoneNumber.create(phone_number: params[:From])

      twiml = Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: "❌ You'll no longer be sent any messages by Roboclaus."
      end

      return render xml: twiml
    elsif %w[69 420].include?(body)
      twiml = Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: '🤙 nice'
      end

      return render xml: twiml
    end

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body: '🌲 No longer feeling the whole Christmas thing? Reply STOP to this message.'
    end

    render xml: twiml
  end
end
