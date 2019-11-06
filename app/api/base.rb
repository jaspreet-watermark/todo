module API
  class Base < Grape::API
    PREFIX = '/api'
    mount API::V1::Mount => '/v1'
  end
end
