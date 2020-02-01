Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :manufacturers, only: [:index, :show, :new, :create, :edit, :update]
  resources :subsidiaries
  resources :car_categories
  resources :car_models, only: [:index, :show, :new, :create, :edit, :update]
  resources :clients
  resources :rentals, only: [:index, :show, :new, :create] do
    get 'search', on: :collection
    get 'start', on: :member
    patch 'cancel', on: :member
    resources :car_rentals, only: [:create]
  end
  resources :cars, only: [:index, :show, :new, :create]
  resources :car_rentals, only: [:show]
  namespace :api do
    namespace :v1 do
      resources :cars, only: [:index, :show, :create, :update, :destroy] do
        patch 'status', on: :member
      end
    end
  end
end