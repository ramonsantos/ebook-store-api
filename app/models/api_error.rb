# frozen_string_literal: true

class ApiError < StandardError
  attr_accessor :http_status, :options

  def initialize(http_status, options)
    @http_status = http_status
    @options = options
  end
end
