# frozen_string_literal: true

require 'rails_helper'

describe 'POST /sign_up', type: :request do
  include_context 'request_shared_context'

  let(:attributes) { { email: 'user.test@gmail.com', password: '123456' } }

  context 'when success' do
    it do
      expect do
        post(sign_up_path, headers: headers, params: request_body)
      end.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.body).to eq('{"info":"User created with success."}')
    end
  end

  context 'when error' do
    context 'when BadRequest error' do
      let(:attributes) { { password: '123456' } }

      let(:sign_up_blank_attribute_error_response) do
        fixture('authentication/responses/sign_up_blank_attribute_error_response.json')
      end

      it do
        expect do
          post(sign_up_path, headers: headers, params: request_body)
        end.not_to change(User, :count)

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq(sign_up_blank_attribute_error_response)
      end
    end

    context 'when UnprocessableEntity error' do
      context 'when User already exists' do
        let(:sign_up_user_already_exists_error_response) do
          fixture('authentication/responses/sign_up_user_already_exists_error_response.json')
        end

        before { create(:user) }

        it do
          expect do
            post(sign_up_path, headers: headers, params: request_body)
          end.not_to change(User, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(sign_up_user_already_exists_error_response)
        end
      end

      context 'when password is too short' do
        let(:attributes) { { email: 'user.test@gmail.com', password: '12345' } }

        let(:sign_up_user_password_too_short_error_response) do
          fixture('authentication/responses/sign_up_user_password_too_short_error_response.json')
        end

        it do
          expect do
            post(sign_up_path, headers: headers, params: request_body)
          end.not_to change(User, :count)

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(sign_up_user_password_too_short_error_response)
        end
      end
    end
  end
end
