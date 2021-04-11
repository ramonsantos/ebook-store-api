# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound,       with: :render_record_not_found_error
  rescue_from ActiveRecord::RecordInvalid,        with: :render_invalid_error
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing_error

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

  private

  def build_errors(method, error, options = {})
    ApiErrorSerializer.new(error, options).serialize(method)
  end
end
