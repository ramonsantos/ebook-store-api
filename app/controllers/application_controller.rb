# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ApiError, with: :render_error

  protected

  def render_error(error)
    render json: ApiErrorSerializer.new(error).serialize, status: error.http_status
  end

  private

  def render_server_error?(error)
    !error.is_a?(ApiError) && Rails.env.production?
  end
end
