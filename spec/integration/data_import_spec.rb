# frozen_string_literal: true

require 'rails_helper'

RSpec::Matchers.define :be_customer_waiting do
  match do |appointment|
    appointment.customer_waiting == true
  end
end

RSpec.describe 'Importing data', type: :request do
  subject { post('/api/import', params: file_fixture('import_data.json').read, headers: { 'CONTENT_TYPE' => 'application/json' }) }

  context 'with valid data' do
    it 'creates appointments' do
      subject

      expect(Appointment.last).to be_customer_waiting
    end

    it 'creates work orders' do
      subject

      work_order = WorkOrder.find_by(order_number: 'DS1133')

      expect(work_order.starting_at).to match DateTime.parse('2020-02-10T08:00')
      expect(work_order.ending_at).to match DateTime.parse('2020-02-10T16:00')
      expect(work_order.description).to eq "Tire Change\nService Check"
    end

    it 'creates cars' do
      subject

      car = Appointment.last.car

      expect(car.registration_number).to eq 'HG-XX1127'
      expect(car.info).to eq "VIN: WDC2539641F3276904\nModel:MB GLC 43 AMG 4M"
    end

    it 'creates customers' do
      subject

      customer = Appointment.last.customer

      expect(customer.name).to eq 'Dejan Stokanic'
      expect(customer.phone_number).to eq '+48606114110'
    end
  end

  context 'with multiple valid data' do
    subject { post('/api/import', params: file_fixture('import_triple_data.json').read, headers: { 'CONTENT_TYPE' => 'application/json' }) }

    it 'sends an email with success message' do
      subject
      mail = AppointmentMailer.deliveries.last

      expect(mail.body).to eq("Succefully imported '3' appointments")
    end
  end

  context 'with invalid data' do
    subject { post('/api/import', params: file_fixture('invalid_import_data.json').read, headers: { 'CONTENT_TYPE' => 'application/json' }) }

    it 'sends an email with error messages' do
      subject
      mail = AppointmentMailer.deliveries.last

      expect(mail.body).to eq("Failed to import '1' appointments. Reason: Car registration number can't be blank")
    end

    it 'logs the error' do
      expect(TjekvikLogger).to receive(:log_error).with("Car registration number can't be blank")
      subject
    end

    it 'returns json error message' do
      subject

      expect(response.status).to eq 400

      expect(response.body).to eq({
        error: "Car registration number can't be blank",
      }.to_json)
    end
  end
end
