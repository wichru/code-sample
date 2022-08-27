# frozen_string_literal: true

module Appointments
  module Responses
    class ManageResponses < Base
      RESPONSES_DEFINITIONS = {
        default: SuccessResponse,
        failure_response: FailureResponse,
      }.freeze

      def call
        RESPONSES_DEFINITIONS[type].new(email, responses_hash).call
      end

      attr_reader :email, :responses_hash

      private

      def type
        responses_hash[:failure_appointments].any? ? :failure_response : :default
      end
    end
  end
end
