# frozen_string_literal: true

shared_context 'request_shared_context' do
  let(:headers) { { 'Accept': 'application/vnd.ebookstore.v1+json' } }
  let(:parsed_response) { JSON.parse(response.body) }

  let(:request_body) do
    {
      data: {
        type: 'category',
        attributes: attributes
      }
    }
  end
end
