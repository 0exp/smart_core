# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::Attribute::ValueFinalizer::Method
  # @param finalizer [String, Symbol]
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
    instance.send(finalizer, value)
  end

  private

  # @return [String, Symbol]
  #
  # @api private
  # @since 0.5.0
  attr_reader :finalizer
end
