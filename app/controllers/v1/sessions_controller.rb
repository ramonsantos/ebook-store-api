# frozen_string_literal: true

module V1
  class SessionsController < Devise::SessionsController
    respond_to :json

    def create
      self.resource = warden.authenticate(auth_options)

      if resource.present?
        sign_in(resource_name, resource)
        respond_with resource
      else
        raise UnauthorizedError
      end
    end

    private

    def respond_with(_resource, _opts = {})
      render json: { token: jwt_token }, status: :created
    end

    def respond_to_on_destroy
      head :no_content
    end

    def jwt_token
      request.env['warden-jwt_auth.token']
    end
  end
end
