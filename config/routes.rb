Jersey::Application.routes.draw do
  authenticated :user do
    root :to => 'dashboard#show'
  end

  root :to => "home#index"

  devise_for :users
  resources :users
  resources :races

  get '/races/:id/:year/:week' => 'races#show'
  put '/races/:id/:year/:week' => 'races#upate'

  match "dashboard" => "dashboard#show"
end
