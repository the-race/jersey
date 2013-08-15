Jersey::Application.routes.draw do
  authenticated :user do
    root :to => 'dashboard#show'
  end

  root :to => 'home#index'

  devise_for :users

  resources :users
  resources :races
  resources :totals

  get '/races/:id/:year/:week' => 'races#show'

  match 'dashboard' => 'dashboard#show'
end
