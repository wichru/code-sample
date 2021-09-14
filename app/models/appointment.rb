# frozen_string_literal: true

class Appointment < ApplicationRecord
  validates :customer_waiting, inclusion: { in: [true, false] }

  has_one :customer, autosave: true
  has_one :car, autosave: true
  has_many :work_orders, autosave: true
end
