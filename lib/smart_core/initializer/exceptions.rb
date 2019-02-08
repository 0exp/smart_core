# frozen_string_literal: true

module SmartCore::Initializer
  # @api public
  # @since 0.5.0
  Error = Class.new(StandardError)

  # @api public
  # @since 0.5.0
  ArgumentError = Class.new(::ArgumentError)

  # @api public
  # @since 0.5.0
  ParameterError = Class.new(ArgumentError)

  # @api public
  # @since 0.5.0
  ParamOverlapError = Class.new(ParameterError)

  # @api public
  # @since 0.5.0
  OptionError = Class.new(ArgumentError)

  # @api public
  # @since 0.5.0
  OptionOverlapError = Class.new(OptionError)
end
