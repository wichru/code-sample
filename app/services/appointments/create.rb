# frozen_string_literal: true

require 'monads'

module Appointments
  class Create
    def initialize(appointment_params)
      @appointment_params = appointment_params
    end

    def call
      Success(appointment_params: appointment_params)
        .bind(method(:build_appointment))
        .bind(method(:build_customer))
        .bind(method(:build_car))
        .bind(method(:build_work_orders))
        .bind(method(:save_appointment))
    end

    attr_reader :appointment_params, :succeeded_appointments, :failure_appointments, :appointments_errors

    private

    def build_appointment(appointment_params:)
      appointment = Appointment.new(customer_waiting: appointment_params[:details][:waiting])

      Success(appointment_params: appointment_params, appointment: appointment)
    end

    def build_customer(appointment_params:, appointment:)
      Customers::Build.new(appointment: appointment, params: appointment_params).call

      Success(appointment_params: appointment_params, appointment: appointment)
    end

    def build_car(appointment_params:, appointment:)
      Cars::Build.new(appointment, appointment_params).call

      Success(appointment_params: appointment_params, appointment: appointment)
    end

    def build_work_orders(appointment_params:, appointment:)
      WorkOrders::Build.new(appointment, appointment_params).call

      Success(appointment)
    end

    def save_appointment(appointment)
      if appointment.save
        Twilio::TextMessanger.new(appointment.customer, appointment_params[:details][:checkInDateTime]).call if send_sms
        Success(appointment)
      else
        Failure(failure_appointments: appointment, appointments_errors: appointment.errors.full_messages)
      end
    end

    def send_sms
      return false if appointment_params[:jobs][0][:menus][0][:labor].nil?

      appointment_params[:jobs][0][:menus][0][:labor][0][:laborCode] == 'CD'
    end
  end
end
