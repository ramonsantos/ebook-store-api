# frozen_string_literal: true

require 'rails_helper'

describe '/categories', type: :request do
  let(:headers) { { 'Accept': 'application/vnd.ebookstore.v1+json' } }
  let(:category) { create(:category) }

  describe 'GET /categories' do
    context "when there aren't categories" do
      it 'returns a success response' do
        get(categories_url, headers: headers)

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('{"data":[],"meta":{"total":0},"links":{"next":null,"prev":null}}')
      end
    end

    context 'when there are categories' do
      let!(:category) { create(:category) }

      let(:expected_response) do
        {
          'data' => [
            {
              'id' => category.id.to_s,
              'type' => 'category',
              'attributes' => { 'name' => 'Engenharia de Software', 'code' => 'engenharia-de-software' }
            }
          ],
          'meta' => { 'total' => 1 },
          'links' => { 'next' => nil, 'prev' => nil }
        }
      end

      it 'returns a success response' do
        get(categories_url, headers: headers)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq(expected_response)
      end
    end
  end

  describe 'PUT /categories/:category_code' do
    before { category }

    context 'when success' do
      let(:params) { { category: { code: 'saude', name: 'Saúde' } } }

      let(:expected_error_message) do
        '{"errors":[{"title":"The attribute \'name\' can\'t be blank"},{"title":"The attribute \'code\' can\'t be blank"}]}'
      end

      before { put(category_path({ category_code: category.code }), headers: headers, params: params) }

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

    context 'when error' do
      context 'when BadRequest' do
        let(:params) { { category: {} } }

        let(:expected_error_message) do
          '{"errors":[{"title":"Param category is missing or the value is empty"}]}'
        end

        it do
          put(category_path({ category_code: category.code }), headers: headers, params: params)

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq(expected_error_message)
        end
      end

      context 'when NotFound' do
        it do
          put(category_path({ category_code: 'music' }), headers: headers)

          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq('{"errors":[{"title":"Category not found"}]}')
        end
      end

      context 'when UnprocessableEntity' do
        let(:params) { { category: { code: '', name: '' } } }

        let(:expected_error_message) do
          '{"errors":[{"title":"The attribute \'name\' can\'t be blank"},{"title":"The attribute \'code\' can\'t be blank"}]}'
        end

        it do
          put(category_path({ category_code: category.code }), headers: headers, params: params)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(expected_error_message)
        end
      end
    end
  end

  describe 'DELETE /categories/:category_code' do
    context 'when category is not found' do
      it do
        expect do
          delete(category_path({ category_code: 'music' }), headers: headers)
        end.not_to change(Category, :count)

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq('{"errors":[{"title":"Category not found"}]}')
      end
    end

    context 'when destroy category' do
      before { category }

      it do
        expect do
          delete(category_path({ category_code: category.code }), headers: headers)
        end.to change(Category, :count).by(-1)

        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_blank
      end
    end
  end
end
