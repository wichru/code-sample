module Twilio
  class TextMessanger
    include ::TwilioClient

    def initialize(customer, appointment_date)
      @customer = customer
      @appointment_date = appointment_date
    end

    def call
      create_message(style_message(customer.name, appointment_date), customer.phone_number)
    end

    attr_reader :customer, :appointment_date

    private

    def style_message(customer_name, appointment_date)
      "Dear #{customer_name}, we're looking forward to seeing you on #{date_format(appointment_date)}"
    end

    def date_format(appointment_date)
      date = Date.parse appointment_date
      date.strftime('%A, %dth of %B')
    end
  end
end
