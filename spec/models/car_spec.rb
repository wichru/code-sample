# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Car, type: :model do
  it 'is not valid without a registration_number' do
    car = Car.new(registration_number: nil)
    expect(car).to_not be_valid
  end

  it 'is invalid with a registration_number, but without appointment' do
    car = Car.new(registration_number: 'HG-XX1127')
    expect(car).to_not be_valid
  end

  it 'is valid with a registration_number and appointment' do
    appointment = Appointment.create
    car = Car.new(registration_number: 'HG-XX1127', appointment: appointment)
    expect(car).to be_valid
  end
end
