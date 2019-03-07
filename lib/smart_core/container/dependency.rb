# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Dependency < SmartCore::Container::Entity
  # @param dependency_definition [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(dependency_definition)
    @dependency_definition = dependency_definition
  end

  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def call
    # TODO: add memoization abilities
    dependency_definition.call
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.5.0
  attr_reader :dependency_definition
end
