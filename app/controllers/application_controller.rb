class ApplicationController < ActionController::API
  include JwtAuthenticator
  before_action :authenticate
end
