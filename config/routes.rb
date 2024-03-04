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
      get 'list_users'
      get 'donation_history'
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
