# frozen_string_literal: true

module SmartCore::Initializer
  # @api public
  # @since 0.5.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.5.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.5.0
  IncompatibleFinalizerTypeError = Class.new(ArgumentError)

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

  # @api public
  # @since 0.5.0
  IncorrectAttributeNameError = Class.new(Error)

  # @api public
  # @since 0.5.0
  UnregisteredTypeError = Class.new(Error)

  # @api public
  # @since 0.5.0
  UnsupportedAttributePrivacyError = Class.new(Error)

  # @api public
  # @since 0.5.0
  TypeError = Class.new(ArgumentError)
end
