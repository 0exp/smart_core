# frozen_string_literal: true

module SmartCore::Types
  # @api public
  # @since 0.9.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.9.0
  ArgumentError = Class.new(SmartCore::ArgumentError)
end
