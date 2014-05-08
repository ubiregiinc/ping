Rails.application.routes.draw do
  resource :newrelic, only: [:create]
end
