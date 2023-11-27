Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow: true do
    resources :answers, only: %i[create]
  end
  
  root to: 'questions#index'
end