# frozen_string_literal: true

require 'monads'

module WorkOrders
  class Build
    def initialize(appointment, params)
      @appointment = appointment
      @params = params
    end

    def call
      Success(appointment)
        .bind(method(:build_object))
    end

    attr_reader :appointment, :params

    private

    def build_object(appointment)
      params['jobs'].each do |job|
        appointment.work_orders.build(build_params(job))
      end

      Success(appointment)
    end

    def build_params(job)
      {
        order_number: job['jobId'],
        description: "#{job['labor'].first['description']}\n#{job['menus'].first['description']}",
        starting_at: check_in_date(params[:details]),
        ending_at: check_out_date(params[:details]),
      }
    end

    def check_in_date(details)
      details[:checkInDateTime].tr(',', ':')
    end

    def check_out_date(details)
      details[:checkOutDateTime].tr(',', ':')
    end
  end
end
