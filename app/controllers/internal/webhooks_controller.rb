class Internal::WebhooksController < ActionController::API
  def twilio
    blocked = BlockedPhoneNumber.exists?(phone_number: params[:To])

    if blocked && params[:Body].to_s.strip.downcase == 'start'
      BlockedPhoneNumber.where(phone_number: params[:To]).destroy_all

      return render xml: Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: '🎅 Welcome back to Roboclaus!'
      end
    elsif blocked
      return render xml: Twilio::TwiML::MessagingResponse.new
    end

    if params[:Body].to_s.strip.downcase == 'stop'
      BlockedPhoneNumber.create(phone_number: params[:To])
      return render xml: Twilio::TwiML::MessagingResponse.new do |r|
        r.message body: "You'll no longer be sent any messages by Roboclaus."
      end
    end

    render xml: Twilio::TwiML::MessagingResponse.new do |r|
      r.message body: 'No longer feeling the whole Christmas thing? Reply STOP to this message.'
    end
  end
end
