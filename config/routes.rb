# frozen_string_literal: true

Rails.application.routes.draw do
  api_version(module: 'V1', default: true, header: { name: 'Accept', value: 'application/vnd.ebookstore.v1+json' }) do
    devise_for :users, controllers: { sessions: 'v1/sessions', registrations: 'v1/registrations' }, skip: [:registrations, :sessions]
    devise_scope :user do
      post   '/sign_up',  to: 'registrations#create'
      post   '/sign_in',  to: 'sessions#create'
      delete '/sign_out', to: 'sessions#destroy'
    end

    resources :categories, param: :category_code, only: [:create, :destroy, :index, :update]
  end
end
