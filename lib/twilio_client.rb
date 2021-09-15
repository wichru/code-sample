# frozen_string_literal: true

module TwilioClient
  extend self

  def create_message(message, customer_number)
    client.messages.create(
      {
        from: Rails.application.secrets.twilio_phone_number,
        to: customer_number,
        body: message,
      },
    )
  end

  private

  def client
    @client ||= Twilio::REST::Client.new
  end
end
