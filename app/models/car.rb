# frozen_string_literal: true

class Car < ApplicationRecord
  belongs_to :appointment

  validates :registration_number, presence: true
end
