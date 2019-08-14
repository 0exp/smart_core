# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::Attribute::ValueFinalizer::Lambda
  # @param finalizer [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(finalizer)
    @finalizer = finalizer
  end

  # @param value [Any]
  # @param instance [Any]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def finalize(value, instance)
    instance.instance_exec(value, &finalizer)
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.5.0
  attr_reader :finalizer
end
