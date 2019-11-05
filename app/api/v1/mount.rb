module V1
  class Mount < Grape::API
    PREFIX = '/api'

    version 'v1', using: :path

    cascade false

    format :json
    default_format :json
    formatter :json, Grape::Formatter::Rabl

    do_not_route_options!

    mount HealthCheck
  end
end
