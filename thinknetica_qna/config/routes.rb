# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    member do
      put 'vote'
    end
    resources :answers, shallow: true do
      member do
        put 'mark_best'
      end
    end
  end
  resource :attachments
end
