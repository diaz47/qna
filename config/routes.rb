Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  resources :questions do
    resources :answers
  end

  match '/answers/select_best_answer/(:id)', to:'answers#select_best_answer', via: 'patch', as:'select_best_answer'
end
