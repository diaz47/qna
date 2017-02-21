Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  resources :questions do
    resources :answers
    resources :best_answer, only: :update
  end
end
