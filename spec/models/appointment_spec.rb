require 'rails_helper'

RSpec.describe Appointment, type: :model do

  it "is invalid without customer waiting flag" do
    appointment = Appointment.new()
    expect(appointment).to_not be_valid
  end

  it "is valid with customer waiting flag false" do
    appointment = Appointment.new(customer_waiting: false)
    expect(appointment).to be_valid
  end

  it "is valid with customer waiting flag true" do
    appointment = Appointment.new(customer_waiting: true)
    expect(appointment).to be_valid
  end
end
