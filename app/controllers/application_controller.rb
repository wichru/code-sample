class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, prepend: true
  include TjekvikLogger
end
