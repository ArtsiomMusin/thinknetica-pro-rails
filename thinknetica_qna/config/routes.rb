# frozen_string_literal: true
Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'questions#index'

  devise_scope :user do
    post 'users/build_by_email'
  end

  concern :voted do
    member do
      put 'vote_yes'
      put 'vote_no'
      put 'reject_vote'
    end
  end
  concern :commented do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:voted, :commented] do
    resources :answers, concerns: [:voted, :commented], shallow: true do
      member do
        put 'mark_best'
      end
    end
  end
  resource :attachments

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end
end
