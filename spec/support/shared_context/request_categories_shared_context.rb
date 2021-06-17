# frozen_string_literal: true

shared_context 'request_categories_shared_context' do
  let(:category) { create(:category) }
  let(:category_not_found_response) { fixture('categories/responses/category_not_found_error_response.json') }
end
