# frozen_string_literal: true

module V1
  class RegistrationsController < Devise::RegistrationsController
    before_action :required_params, only: [:create]

    respond_to :json

    # POST /sign_up
    def create
      build_resource(user_params).save!

      render json: { info: 'User created with success.' }, status: :created
    end

    def user_params
      params.require(:data).require(:attributes).permit(:email, :password)
    end

    def required_params
      [:email, :password].each { |required_param| user_params.require(required_param) }
    end
  end
end
