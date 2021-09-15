# frozen_string_literal: true

require 'monads'

module Cars
  class Build
    def initialize(appointment, params)
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
      car = appointment.build_car(build_params(params))

      Success(car)
    end

    def build_params(params)
      {
        registration_number: params['vehicle']['licence_plate'],
        info: car_info(params[:vehicle]),
      }
    end

    def car_info(vehicle)
      "VIN: #{vehicle[:vin]}\nModel:#{vehicle[:brand]} #{vehicle[:model]}"
    end
  end
end
