# frozen_string_literal: true

require 'rails_helper'

describe 'GET /categories', type: :request do
  include_context 'request_categories_shared_context'

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
