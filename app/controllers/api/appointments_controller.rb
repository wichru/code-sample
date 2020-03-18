class Api::AppointmentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    email = batch_create_appointments_params[:_json].first["contact"]["email"]
    succeeded_appointments, failure_appointments, appointments_errors = [], [], []

    batch_create_appointments_params[:_json].each do |appointment_params|
      appointment = Appointment.new(customer_waiting: appointment_params[:details][:waiting])
      customer = appointment.build_customer(
        name: "#{appointment_params["customer"]["first_name"]} #{appointment_params["customer"]["last_name"]}",
        email: appointment_params["contact"]["email"],
        phone_number: appointment_params["contact"]["phone"])
      car = appointment.build_car(
        registration_number: appointment_params["vehicle"]["licence_plate"],
        info: car_info(appointment_params[:vehicle]))

      appointment_params["jobs"].each do |job|
        appointment.work_orders.build(
          order_number: job["jobId"],
          description: "#{job["labor"].first["description"]}\n#{job["menus"].first["description"]}",
          starting_at: check_in_date(appointment_params[:details]),
          ending_at: check_out_date(appointment_params[:details]))
      end

      if appointment.save
        succeeded_appointments << appointment
      else
        failure_appointments << appointment
        appointments_errors += appointment.errors.full_messages
        log_error(appointments_errors)
      end
    end

    if failure_appointments.any?
      AppointmentMailer.failed_mail(email, failure_appointments.size, appointments_errors).deliver_now

      render json: {
        error: appointments_errors.join(', ')
      }, status: 400
    else
      AppointmentMailer.success_mail(email, succeeded_appointments.size).deliver_now if succeeded_appointments.any?
      render json: {
        success: succeeded_appointments.map { |appointment|
          appointment.as_json(include: [:car, :customer, :work_orders]) }}
    end
  end

  private

  def car_info(vehicle)
    "VIN: #{vehicle[:vin]}\nModel:#{vehicle[:brand]} #{vehicle[:model]}"
  end

  def check_in_date(details)
    details[:checkInDateTime].tr(',', ':')
  end

  def check_out_date(details)
    details[:checkOutDateTime].tr(',', ':')
  end

  def batch_create_appointments_params
    params.permit(_json: ["details": [:checkInDateTime, :checkOutDateTime, :waiting], "vehicle": [:licence_plate, :vin, :brand, :model], "customer": [:first_name, :last_name], "contact": [:contact_method, :email, :phone], jobs:[:jobId, labor: [:description], menus: [:description]]])
  end
end
