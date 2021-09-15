# frozen_string_literal: true

module TjekvikLogger
  module_function

  def log_error(message)
    Logger.new($stdout).error(message)
  end
end
