Rails.application.routes.draw do
  get 'donations/index'
  root 'dashboards#show'

  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end
  get '/groups', to: 'groups#index'
  resources :groups do
    member do
      get :delete
    end
  end

  resources :books

  resources :users
  resources :users do
    member do
      get :delete
      get :details
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # donation routes
  resources :donations, only: [:index]
  resources :donations do
    member do
      get :delete
    end
  end
  
  Rails.application.routes.draw do
    resources :donations
  end

  resources :campaigns
  resources :campaigns do
    member do
      get :delete
    end
  end

end
