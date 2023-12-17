Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow: true do
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