Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :liked
      post :disliked
    end
  end

  resources :questions, shallow: true, concerns: %i[votable] do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :mark_as_the_best
      end
    end
  end

  resources :files, shallow: true, only: :destroy
  resources :links, shallow: true, only: :destroy
  resources :rewards, shallow: true, only: :index
  
  root to: 'questions#index'
end