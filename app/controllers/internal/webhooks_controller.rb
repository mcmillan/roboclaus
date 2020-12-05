class Internal::WebhooksController < ActionController::API
  def twilio
    return render xml: Twilio::TwiML::MessagingResponse.new if BlockedPhoneNumber.exists?(phone_number: params[:To])

    if params[:Body].to_s.strip.downcase == 'stop'
      BlockedPhoneNumber.create(phone_number: params[:To])
      return render xml: Twilio::TwiML::MessagingResponse.new
    end

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message body: 'No longer feeling the whole Christmas thing? Reply STOP to this message.'
    end

    render xml: twiml
  end
end
