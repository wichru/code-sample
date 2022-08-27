# frozen_string_literal: true

require 'monads'

module Appointments
  module Responses
    class FailureResponse < Base
      def call
        Success(responses_hash)
          .bind(method(:send_failed_email))
          .bind(method(:log_error))
      end

      attr_reader :email, :responses_hash

      private

      def send_failed_email(responses_hash)
        AppointmentMailer.failed_mail(email, responses_hash[:failure_appointments].size,
                                      responses_hash[:errors]).deliver_now

        Success(responses_hash)
      end

      def log_error(responses_hash)
        log_error = ::TjekvikLogger.log_error(responses_hash[:errors].join(', '))

        Failure(log_error)
      end
    end
  end
end
