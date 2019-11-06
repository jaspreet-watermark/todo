module API::V1
  class Mount < Grape::API

    cascade false

    format :json
    default_format :json
    formatter :json, Grape::Formatter::Rabl

    # rescue Exceptions
    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      error_response(message: 'Record Not Found!', status: 404)
    end

    # logger
    if Rails.env.development?
      require 'grape_logging'
      logger.formatter = GrapeLogging::Formatters::Rails.new
      use GrapeLogging::Middleware::RequestLogger, { logger: logger }
    end

    do_not_route_options!

    mount HealthCheck
    mount Items
  end
end

