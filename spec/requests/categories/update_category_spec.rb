# frozen_string_literal: true

require 'rails_helper'

describe 'PUT /categories/:category_code', type: :request do
  include_context 'request_shared_context'
  include_context 'request_categories_shared_context'

  let(:path_params) { { category_code: category.code } }

  before { put(category_path(path_params), headers: headers, params: request_body) }

  context 'when success' do
    context 'when one attribute' do
      let(:attributes) { { code: 'saude' } }

      it 'returns success response' do
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_blank
      end

      it 'updates de category' do
        category.reload
        expect(category.code).to eq('saude')
        expect(category.name).to eq('Engenharia de Software')
      end
    end

    context 'when all attributes' do
      let(:attributes) { { code: 'saude', name: 'Saúde' } }

      it 'returns success response' do
        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_blank
      end

      it 'updates de category' do
        category.reload
        expect(category.code).to eq('saude')
        expect(category.name).to eq('Saúde')
      end
    end
  end

  context 'when error' do
    context 'when UnprocessableEntity' do
      let(:attributes) { { name: '' } }

      let(:expected_error_message) do
        {
          'errors' => [
            {
              'title' => 'Attribute is required',
              'detail' => "The attribute 'name' can't be blank",
              'code' => 'attribute_blank',
              'source' => {
                'pointer' => '/data/attributes/name'
              }
            }
          ]
        }
      end

      it do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response).to eq(expected_error_message)
      end
    end

    context 'when NotFound' do
      let(:path_params) { { category_code: 'music' } }
      let(:attributes) { nil }

      it do
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq(category_not_found_response)
      end
    end
  end
end
