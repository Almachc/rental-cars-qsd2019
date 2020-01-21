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
    resources :car_rentals, only: [:create]
  end
  resources :car_rentals, only: [:show]
end