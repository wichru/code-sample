class Appointment < ApplicationRecord
  validates_inclusion_of :customer_waiting, in: [true, false]

  has_one :customer, autosave: true
  has_one :car, autosave: true
  has_many :work_orders, autosave: true
end
