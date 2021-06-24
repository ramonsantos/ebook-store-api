# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pundit

  rescue_from ActiveRecord::RecordNotFound,       with: :render_record_not_found_error
  rescue_from ActiveRecord::RecordInvalid,        with: :render_invalid_error
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing_error
  rescue_from UnauthorizedError,                  with: :render_unauthorized_error
  rescue_from Pundit::NotAuthorizedError,         with: :user_not_authorized_error

  protected

  def render_record_not_found_error(error)
    options = { identifier: params[:category_code] }

    render json: build_errors(:record_not_found, error, options), status: :not_found
  end

  def render_invalid_error(error)
    render json: build_errors(:record_invalid, error), status: :unprocessable_entity
  end

  def render_parameter_missing_error(error)
    render json: build_errors(:parameter_missing, error), status: :bad_request
  end

  def render_unauthorized_error(error)
    render json: build_errors(:unauthorized, error), status: :unauthorized
  end

  def user_not_authorized_error(_error)
    render json: build_errors(:not_authorized, nil), status: :forbidden
  end

  private

  def build_errors(method, error, options = {})
    ApiErrorSerializer.new(error, options).serialize(method)
  end
end
