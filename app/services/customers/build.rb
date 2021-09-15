require 'monads'

module Customers
  class Build
    def initialize(appointment:, params:)
      @appointment = appointment
      @params = params
    end

    def call
      Success(appointment)
        .bind(method(:build_object))
    end

    attr_reader :appointment, :params

    private

    def build_object(appointment)
      customer = appointment.build_customer(build_params(params))

      Success(customer)
    end

    def build_params(params)
      {
        name: "#{params['customer']['first_name']} #{params['customer']['last_name']}",
        email: params['contact']['email'],
        phone_number: params['contact']['phone'],
      }
    end

    def car_info(vehicle)
      "VIN: #{vehicle[:vin]}\nModel:#{vehicle[:brand]} #{vehicle[:model]}"
    end
  end
end
