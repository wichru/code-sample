class AppointmentMailer < ApplicationMailer

  def success_mail(mail, appointments)
    mail(to: mail, subject: "Success", body: "Succefully imported '#{appointments}' appointments")
  end

  def failed_mail(mail, appointments, errors)
    mail(to: mail, subject: "Error", body: "Failed to import '#{appointments}' appointments. Reason: #{errors.join(', ')}")
  end
end
