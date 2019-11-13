module API::V1
  class Mount < Grape::API

    cascade false

    format :json
    default_format :json
    formatter :json, Grape::Formatter::Rabl

    # rescue Exceptions
    rescue_from Mongoid::Errors::DocumentNotFound do |e|
      error! 'Record Not Found!', 404
    end

    # logger
    # if Rails.env.development?
    require 'grape_logging'
    logger.formatter = GrapeLogging::Formatters::Rails.new
    use GrapeLogging::Middleware::RequestLogger, { logger: logger }
    # end

    do_not_route_options!

    mount HealthCheck
    mount Items
    add_swagger_documentation base_path: '/api/v1/',
                              info: {
                                  title: 'Todo',
                                  description: 'RESTful API for CRUD'
                              },
                              array_use_braces: true

    # undefined route error
    route :any, '*path' do
      error! 'Route is not found', 404
    end
  end
end

