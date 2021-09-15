# frozen_string_literal: true

class Api::AppointmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  include AppointmentsHelper

  def create
    @succeeded_appointments, @failure_appointments, @appointments_errors = [], [], []

    batch_create_appointments_params[:_json].each do |appointment_params|
      appointment = ::Appointments::Create.new(appointment_params).call
      assign_response(appointment, @succeeded_appointments, @failure_appointments, @appointments_errors)
    end

    result = ::Appointments::Responses::ManageResponses.new(email, responses_hash).call
    render_result(result)
  end

  private

  def render_result(result)
    result.success? ? success_response(@succeeded_appointments) : failure_response(@appointments_errors)
  end

  def responses_hash
    {
      succeeded_appointments: @succeeded_appointments,
      failure_appointments: @failure_appointments,
      errors: @appointments_errors,
    }
  end

  def email
    batch_create_appointments_params[:_json].first['contact']['email']
  end

  def batch_create_appointments_params
    params.permit(_json: [
                    details: %i[checkInDateTime checkOutDateTime waiting],
                    vehicle: %i[licence_plate vin brand model],
                    customer: %i[first_name last_name],
                    contact: %i[contact_method email phone],
                    jobs: [:jobId, { labor: [:description], menus: [:description, { labor: [:laborCode] }] }],
                  ])
  end
end
