Rails.application.routes.draw do
  # API routes
  mount API::Base, at: API::Base::PREFIX
  mount GrapeSwaggerRails::Engine => '/swagger'
end
