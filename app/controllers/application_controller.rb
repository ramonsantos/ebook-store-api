# frozen_string_literal: true

class ApplicationController < ActionController::API
  around_action :handle_errors

  protected

  def handle_errors
    yield
  rescue ActionController::ParameterMissing => e
    render_api_error("Param #{e.param} is missing or the value is empty", :bad_request)
  rescue ActiveRecord::RecordNotFound => e
    render_api_error("#{e.model} not found", :not_found)
  rescue ActiveRecord::RecordInvalid => e
    error_messages = [].tap do |error_message|
      e.record.errors.messages.each do |key, value|
        value.each do |type|
          error_message << "The attribute '#{key}' #{type}"
        end
      end
    end

    render_api_error(error_messages, :unprocessable_entity)
  end

  private

  def render_api_error(messages, code)
    data = { errors: Array.wrap(messages).map! { |message| { title: message } } }

    render json: data, status: code
  end
end
