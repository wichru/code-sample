module TjekvikLogger
  def log_error(message)
    Logger.new(STDERR).error(message)
  end
end
