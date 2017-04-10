Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks'}
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :users, on: :collection
      end
    end
  end

  concern :votable do 
    member do
      post :vote
      delete :delete_vote
    end
  end
  
  resources :questions, concerns: :votable do
    resources :answers, shallow: true, concerns: :votable do
      patch :select_best_answer, on: :member
    end
  end
  resources :attachments, only: [:destroy]
  resources :comments, only: [:create]

  mount ActionCable.server => '/cable'
end
