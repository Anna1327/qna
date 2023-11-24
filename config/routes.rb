Rails.application.routes.draw do
  resources :questions
    resources :answers, only: :create
end
