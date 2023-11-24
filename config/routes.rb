Rails.application.routes.draw do
  devise_for :users
  resources :questions
    resources :answers, only: :create
  
  root to: 'questions#index'
end
