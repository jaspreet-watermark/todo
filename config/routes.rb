Rails.application.routes.draw do
  # API routes
  mount V1::Mount => V1::Mount::PREFIX
end
