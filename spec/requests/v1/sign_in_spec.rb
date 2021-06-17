# frozen_string_literal: true

require 'rails_helper'

describe 'POST /sign_up', type: :request do
  include_context 'request_shared_context'

  before { create(:user) }

  context 'when correct credentials' do
    it 'creates token' do
      post(sign_in_path, headers: headers, params: { user: attributes_for(:user) })

      expect(response).to have_http_status(:created)
      expect(parsed_response['token']).to match(/[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+?\.[a-zA-Z0-9\-_]+$/)
    end
  end

  context 'when invalid credentials' do
    let(:sign_in_unauthorized_error_response) do
      fixture('authentication/responses/sign_in_unauthorized_error_response.json')
    end

    it 'does not create token' do
      post(sign_in_path, headers: headers, params: { user: { email: 'user123@gmail.com', password: 'as123456' } })

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq(sign_in_unauthorized_error_response)
    end
  end
end
