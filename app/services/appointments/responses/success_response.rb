# frozen_string_literal: true

require 'monads'

module Appointments
  module Responses
    class SuccessResponse < Base
      def call
        Success(responses_hash)
          .bind(method(:send_success_email))
      end

      attr_reader :email, :responses_hash

      private

      def send_success_email(responses_hash)
        if responses_hash[:succeeded_appointments].any?
          success_mail = AppointmentMailer.success_mail(
            email,
            responses_hash[:succeeded_appointments].size,
          ).deliver_now
        end

        Success(success_mail)
      end
    end
  end
end
