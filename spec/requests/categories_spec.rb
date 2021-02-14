# frozen_string_literal: true

require 'rails_helper'

describe '/categories', type: :request do
  let(:headers) { { 'Accept': 'application/vnd.ebookstore.v1+json' } }

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

  describe 'DELETE /categories/:category_code' do
    context 'when category is not found' do
      it 'returns a success response' do
        expect do
          delete(category_path({ category_code: 'music' }), headers: headers)
        end.not_to change(Category, :count)

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq('{"errors":[{"title":"Category \'music\' not found"}]}')
      end
    end

    context 'when destroy category' do
      let!(:category) { create(:category) }

      it 'returns a success response' do
        expect do
          delete(category_path({ category_code: category.code }), headers: headers)
        end.to change(Category, :count).by(-1)

        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_blank
      end
    end
  end
end
