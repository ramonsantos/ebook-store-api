# frozen_string_literal: true

require 'rails_helper'

describe 'POST /categories', type: :request do
  include_context 'request_shared_context'
  include_context 'request_categories_shared_context'

  context 'when success' do
    let(:attributes) { { code: 'saude', name: 'Saúde' } }

    it 'creates a new Category' do
      expect do
        post(categories_url, headers: headers, params: request_body)
      end.to change(Category, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.body).to include('"attributes":{"name":"Saúde","code":"saude"}')
    end
  end

  context 'when error' do
    context 'when BadRequest error' do
      let(:attributes) { { code: 'historia' } }

      let(:category_blank_attributes_error_response) do
        fixture('categories/responses/category_blank_attributes_error_response.json')
      end

      it do
        expect do
          post(categories_url, headers: headers, params: request_body)
        end.not_to change(Category, :count)

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq(category_blank_attributes_error_response)
      end
    end

    context 'when UnprocessableEntity error' do
      let(:attributes) { { code: 'saude', name: 'Saúde' } }

      let(:category_already_exists_error_response) do
        fixture('categories/responses/category_already_exists_error_response.json')
      end

      before { FactoryBot.create(:category, name: 'Saúde', code: 'saude') }

      it 'creates a new Category' do
        expect do
          post(categories_url, headers: headers, params: request_body)
        end.not_to change(Category, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(category_already_exists_error_response)
      end
    end
  end
end
