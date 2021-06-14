# frozen_string_literal: true

shared_context 'request_categories_shared_context' do
  let(:headers) { { 'Accept': 'application/vnd.ebookstore.v1+json' } }
  let(:category) { create(:category) }
  let(:parsed_response) { JSON.parse(response.body) }
  let(:category_not_found_response) { fixture('categories/responses/category_not_found_error_response.json') }

  let(:request_body) do
    {
      data: {
        type: 'category',
        attributes: attributes
      }
    }
  end
end
