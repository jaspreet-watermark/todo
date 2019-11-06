module API::V1
  class HealthCheck < Grape::API

    desc 'API heath check status'
    get :status, rabl: 'status' do
      @response = OpenStruct.new({ status: 'ok' })
    end
  end
end