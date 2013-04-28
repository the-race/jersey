Jersey::Application.routes.draw do
  authenticated :user do
    root :to => 'dashboard#show'
  end

  root :to => "home#index"

  devise_for :users
  resources :users
  resources :races

  match "dashboard" => "dashboard#show"
end
