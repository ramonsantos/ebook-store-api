# frozen_string_literal: true

Rails.application.routes.draw do
  api_version(module: 'V1', default: true, header: { name: 'Accept', value: 'application/vnd.ebookstore.v1+json' }) do
    resources :categories, param: :category_code, only: [:create, :destroy, :index, :update]
  end
end
