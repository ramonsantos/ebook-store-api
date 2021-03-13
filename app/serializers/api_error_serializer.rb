# frozen_string_literal: true

class ApiErrorSerializer
  attr_reader :error

  def initialize(error)
    @error = error
  end

  def serialize
    { errors: send(error.http_status) }
  end

  private

  def not_found
    model = error.options[:model]

    [
      {
        title: 'Resource not found',
        detail: "The #{model} '#{error.options[:identifier]}' is not found",
        code: :resource_not_found,
        source: {}
      }
    ]
  end

  def bad_request
    record = error.options[:record]

    record.errors.errors.map! do |error|
      {
        title: 'Attribute is required',
        detail: "The attribute '#{error.attribute}' can't be blank",
        code: :attribute_blank,
        source: { pointer: "/data/attributes/#{error.attribute}" }
      }
    end
  end
end
