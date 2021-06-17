# frozen_string_literal: true

require 'rails_helper'

describe 'DELETE /categories/:category_code', type: :request do
  include_context 'request_shared_context'
  include_context 'request_categories_shared_context'

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
