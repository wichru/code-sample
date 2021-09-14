# frozen_string_literal: true

class WorkOrder < ApplicationRecord
  belongs_to :appointment
end
