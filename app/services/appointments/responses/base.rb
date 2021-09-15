# frozen_string_literal: true

module Appointments
  module Responses
    class Base
      def initialize(email, responses_hash)
        @email = email
        @responses_hash = responses_hash
      end
    end
  end
end
