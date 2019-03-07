# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Namespace < SmartCore::Container::Entity
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize
    @container = Class.new(SmartCore::Container)
  end

  # @param dependency_definitions [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def append_definitions(dependency_definitions)
    container.instance_eval(&dependency_definitions)
  end

  # @return [SmartCore::Container]
  #
  # @api private
  # @since 0.5.0
  def call
    # TODO: add memoization abilities
    container.new
  end

  private

  # @return [Class<SmartCore::Container>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :container
end
