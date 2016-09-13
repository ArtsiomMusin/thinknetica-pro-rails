# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voted do
    member do
      put 'vote_yes'
      put 'vote_no'
      put 'reject_vote'
    end
  end

  resources :questions, concerns: [:voted] do
    resources :answers, concerns: [:voted], shallow: true do
      member do
        put 'mark_best'
      end
    end
  end
  resource :attachments
end
