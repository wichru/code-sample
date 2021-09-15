# frozen_string_literal: true

class Api::AppointmentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  include AppointmentsHelper

  def create
    succeeded_appointments, failure_appointments, appointments_errors = [], [], []

    batch_create_appointments_params[:_json].each do |appointment_params|
      appointment = ::Appointments::Create.new(appointment_params).call
      assign_response(appointment, succeeded_appointments, failure_appointments, appointments_errors)
    end

    if failure_appointments.any?
      failure_response(appointments_errors, failure_appointments)
    else
      success_response(succeeded_appointments)
    end
  end

  private

  def failure_response(appointments_errors, failure_appointments)
    send_failed_email(failure_appointments, appointments_errors)
    render json: {
      error: appointments_errors.join(', '),
    }, status: :bad_request
  end

  def success_response(succeeded_appointments)
    send_success_email(succeeded_appointments)
    render json: {
      success: succeeded_appointments.map do |appointment|
                 appointment.as_json(include: %i[car customer work_orders])
               end,
    }
  end

  def send_failed_email(failure_appointments, appointments_errors)
    AppointmentMailer.failed_mail(email, failure_appointments.size, appointments_errors).deliver_now
  end

  def send_success_email(succeeded_appointments)
    AppointmentMailer.success_mail(email, succeeded_appointments.size).deliver_now if succeeded_appointments.any?
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
                    jobs: [:jobId, { labor: [:description], menus: [:description] }],
                  ])
  end
end
