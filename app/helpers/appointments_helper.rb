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
end
