# frozen_string_literal: true

class ApiErrorSerializer
  attr_reader :error, :options

  def initialize(error, options = {})
    @error   = error
    @options = options
  end

  def serialize(method)
    { errors: send(method) }
  end

  private

  def record_not_found
    [
      {
        title: 'Resource not found',
        detail: "The #{error.model} '#{options[:identifier]}' is not found",
        code: :resource_not_found,
        source: {}
      }
    ]
  end

  def record_invalid
    record.errors.errors.map! do |error|
      {
        title:  I18n.t("api_error.record_invalid.#{error.type}.title"),
        detail: build_detail(record, error),
        code:   I18n.t("api_error.record_invalid.#{error.type}.code"),
        source: { pointer: "/data/attributes/#{error.attribute}" }
      }
    end
  end

  def parameter_missing
    [
      {
        title: 'Attribute is required',
        detail: "The attribute '#{error.param}' can't be blank",
        code: :attribute_blank,
        source: { pointer: "/data/attributes/#{error.param}" }
      }
    ]
  end

  def unauthorized
    [
      {
        title: 'Unauthorized',
        detail: 'Invalid Email or password.',
        code: :unauthorized,
        source: {}
      }
    ]
  end

  def not_authorized
    [
      {
        title: 'Not authorized',
        detail: 'User not authorized.',
        code: :not_authorized,
        source: {}
      }
    ]
  end

  def build_detail(record, error)
    I18n.t(
      "api_error.record_invalid.#{error.type}.detail",
      entity: record.class,
      attribute: error.attribute,
      count: error.try(:options).try(:fetch, :count, nil)
    )
  end

  def record
    @record ||= error.record
  end
end
