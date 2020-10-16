Rails.application.routes.draw do
root 'webhooks#show'

  post 'webhook' =>'webhooks#webhook'
  post 'search' =>'webhooks#search'
  get '/show' => 'webhooks#show'

resources :webhooks, only: %i[webhook show search]
end
