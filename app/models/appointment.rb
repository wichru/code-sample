# frozen_string_literal: true

class Appointment < ApplicationRecord
  validates :customer_waiting, inclusion: { in: [true, false] }

  has_one :customer, autosave: true, dependent: :destroy
  has_one :car, autosave: true, dependent: :destroy
  has_many :work_orders, autosave: true, dependent: :destroy
end
