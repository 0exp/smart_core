# frozen_string_literal: true

class SmartCore::Operation
  # @api public
  # @since 0.2.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.3.0
  FatalError = Class.new(Error) do
    # @return [SmartCore::Operation::Fatal]
    #
    # @api private
    # @since 0.3.0
    attr_reader :__operation_result__

    # @param operation_result [SmartCore::Operation::Fatal]
    # @return [void]
    #
    # @api private
    # @since 0.3.0
    def initialize(operation_result)
      @__operation_result__ = operation_result
      super()
    end
  end

  # @api public
  # @since 0.2.0
  ArgumentError = Class.new(::SmartCore::ArgumentError)

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

  # @api public
  # @since 0.2.0
  IncompatibleResultObjectKeyError = Class.new(Error)
end
