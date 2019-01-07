# frozen_string_literal: true

class SmartCore::Operation
  # @api public
  # @since 0.2.0
  Error = Class.new(StandardError)

  # @api public
  # @since 0.2.0
  IncorrectAttributeNameError = Class.new(Error)
end
