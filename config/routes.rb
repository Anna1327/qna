require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  get 'comments/new'
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :authorizations, only: %i[new create] do
    get 'email_confirmation/:confirmation_token', action: :email_confirmation, as: :email_confirmation
  end

  concern :votable do
    member do
      post :liked
      post :disliked
    end
  end

  resources :questions, shallow: true, concerns: %i[votable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable] do
      member do
        patch :mark_as_the_best
      end
    end
    resources :subscribers, only: :create
  end

  resources :files, shallow: true, only: :destroy
  resources :links, shallow: true, only: :destroy
  resources :rewards, shallow: true, only: :index
  resources :comments, only: %i[create destroy]
  resources :subscribers, only: :destroy

  get 'search', to: 'search#search'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :users, only: :index

      resources :questions, except: %i[answers] do
        resources :answers, only: :index
      end

      resources :answers, except: :index
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
