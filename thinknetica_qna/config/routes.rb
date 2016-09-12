# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  
  resources :questions do
    member do
      put 'vote_yes'
      put 'vote_no'
      put 'reject_vote'
    end
    resources :answers, shallow: true do
      member do
        put 'mark_best'
        put 'vote_yes'
        put 'vote_no'
        put 'reject_vote'
      end
    end
  end
  resource :attachments
end
