# frozen_string_literal: true

class SmartCore::Operation
  # @api public
  # @since 0.2.0
  Error = Class.new(StandardError)

  # @api public
  # @since 0.2.0
  ArgumentError = Class.new(::ArgumentError)

  # @api public
  # @since 0.2.0
  ParameterError = Class.new(ArgumentError)

  # @api public
  # @since 0.2.0
  ParamOverlapError = Class.new(ParameterError)

  # @api public
  # @since 0.2.0
  OptionError = Class.new(ArgumentError)

  # @api public
  # @since 0.2.0
  OptionOverlapError = Class.new(OptionError)

  # @api public
  # @since 0.2.0
  IncorrectAttributeNameError = Class.new(Error)

  # @api public
  # @since 0.2.0
  ResultMethodIntersectionError = Class.new(Error)
end
