Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  resources :questions do
    resources :answers do
      patch :select_best_answer, on: :member
    end
  end
  resources :attachments, only: [:destroy]

  match '/questions/:question_id/vote/:user_id', to:'questions#vote', via: 'post', as:'vote_question'
  match '/questions/:question_id/vote/:user_id', to:'questions#delete_vote', via: 'delete', as:'delete_vote_question'

  match '/answer/:answer_id/vote/:user_id', to:'answers#vote', via: 'post', as:'vote_answer'
  match '/answer/:answer_id/vote/:user_id', to:'answers#delete_vote', via: 'delete', as:'delete_vote_answer'
end
