# frozen_string_literal: true

require 'rails_helper'

describe 'GET /categories', type: :request do
  include_context 'request_categories_shared_context'

  context "when there aren't categories" do
    it do
      get(categories_url, headers: headers)

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('{"data":[],"meta":{"total":0},"links":{"next":null}}')
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
        'links' => { 'next' => nil }
      }
    end

    it 'returns a success response' do
      get(categories_url, headers: headers)

      expect(response).to have_http_status(:ok)
      expect(parsed_response).to eq(expected_response)
    end
  end

  context 'with pagination' do
    before do
      21.times do |num|
        create(:category, code: "category_#{num}", name: "Category #{num}")
      end
    end

    context 'when first page' do
      it do
        get(categories_url, headers: headers)

        expect(response).to have_http_status(:ok)
        expect(parsed_response['data'].count).to eq(20)
        expect(parsed_response['meta']['total']).to eq(21)
        expect(parsed_response['links']['next']).to eq('/categories?page=2')
      end
    end

    context 'when last page' do
      it do
        get(categories_url, headers: headers, params: { page: 2 })

        expect(response).to have_http_status(:ok)
        expect(parsed_response['data'].count).to eq(1)
        expect(parsed_response['meta']['total']).to eq(21)
        expect(parsed_response['links']['next']).to be_nil
      end
    end

    context 'when blank page' do
      it do
        get(categories_url, headers: headers, params: { page: 3 })

        expect(response).to have_http_status(:ok)
        expect(parsed_response['data']).to eq([])
        expect(parsed_response['meta']['total']).to eq(21)
        expect(parsed_response['links']['next']).to be_nil
      end
    end
  end
end
