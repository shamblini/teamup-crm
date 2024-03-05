Rails.application.routes.draw do
  get 'donations/index'
  root 'dashboards#show'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
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

  # donation routes
  resources :donations, only: [:index]
  resources :donations do
    member do
      get :delete
    end
  end

  post 'upload_csv', to: 'donations#upload_csv', as: 'upload_csv'

  # campaign routes
  resources :campaigns, only: [:index]
  resources :campaigns do
    member do
      get :delete
    end
  end

end
