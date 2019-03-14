# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Initializer::Extension
  # @param additional_initialization_flow [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(additional_initialization_flow)
    @additional_initialization_flow = additional_initialization_flow
  end

  # @param instance [Object]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def call(instance)
    additional_initialization_flow.call(instance)
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def dup
    self.class.new(additional_initialization_flow)
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.5.0
  attr_reader :additional_initialization_flow
end
