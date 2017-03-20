Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do 
    member do
      post :vote
      delete :delete_vote
    end
  end
  
  resources :questions do
    concerns :votable
    resources :answers do
      concerns :votable, votable_param: 'answer_id'
      patch :select_best_answer, on: :member
    end
  end
  resources :attachments, only: [:destroy]

end
