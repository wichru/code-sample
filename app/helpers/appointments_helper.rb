# frozen_string_literal: true

module AppointmentsHelper
  def assign_response(appointment, succeeded_appointments, failure_appointments, appointments_errors)
    if appointment.success?
      succeeded_appointments << appointment.value!
    else
      (failure_appointments << appointment.failure[:failure_appointments]) &&
        (appointments_errors << appointment.failure[:appointments_errors])
    end
  end

  private

  def success_response(succeeded_appointments)
    render json: {
      success: succeeded_appointments.map do |appointment|
        appointment.as_json(include: %i[car customer work_orders])
      end,
    }
  end

  def failure_response(appointments_errors)
    render json: {
      error: appointments_errors.join(', '),
    }, status: :bad_request
  end
end
