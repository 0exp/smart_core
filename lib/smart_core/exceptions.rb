# frozen_string_literal: true

module SmartCore
  # @api public
  # @since 0.5.0
  Error = Class.new(StandardError)

  # @api public
  # @since 0.5.0
  ArgumentError = Class.new(::ArgumentError)
end
