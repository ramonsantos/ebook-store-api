# frozen_string_literal: true

require 'rails_helper'

describe '/categories', type: :request do
  let(:headers) { { 'Accept': 'application/vnd.ebookstore.v1+json' } }
  let(:category) { create(:category) }
  let(:parsed_response) { JSON.parse(response.body) }
  let(:category_not_found_response) { fixture('categories/responses/category_not_found_error_response.json') }

  let(:category_blank_attributes_error_response) do
    fixture('categories/responses/category_blank_attributes_error_response.json')
  end

  let(:request_body) do
    {
      data: {
        type: 'category',
        attributes: attributes
      }
    }
  end

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
        expect(parsed_response).to eq(expected_response)
      end
    end
  end

  describe 'POST /categories' do
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
      let(:invalid_attributes) { { code: 'historia' } }

      context 'when BadRequest error' do
        let(:attributes) { {} }

        it do
          expect do
            post(categories_url, headers: headers, params: request_body)
          end.to change(Category, :count).by(0)

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to eq(category_blank_attributes_error_response)
        end
      end

      context 'when Conflict error' do
        let(:attributes) { { code: 'saude', name: 'Saúde' } }

        let(:category_already_exists_error_response) do
          fixture('categories/responses/category_already_exists_error_response.json')
        end

        before { FactoryBot.create(:category, name: 'Saúde', code: 'saude') }

        it 'creates a new Category' do
          expect do
            post(categories_url, headers: headers, params: request_body)
          end.to change(Category, :count).by(0)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(category_already_exists_error_response)
        end
      end
    end
  end

  describe 'PUT /categories/:category_code' do
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
      context 'when BadRequest' do
        context 'when one attribute is blank' do
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
            expect(response).to have_http_status(:bad_request)
            expect(parsed_response).to eq(expected_error_message)
          end
        end

        context 'when all attributes are blank' do
          let(:attributes) { { code: '', name: '' } }

          it do
            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(category_blank_attributes_error_response)
          end
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

  describe 'DELETE /categories/:category_code' do
    context 'when category is not found' do
      it do
        expect do
          delete(category_path({ category_code: 'music' }), headers: headers)
        end.not_to change(Category, :count)

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq(category_not_found_response)
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
