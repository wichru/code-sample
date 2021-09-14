# frozen_string_literal: true

module TjekvikLogger
  def log_error(message)
    Logger.new($stderr).error(message)
  end
end
