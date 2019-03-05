# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Namespace
  # @param inner_definitions [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(inner_definitions)
    @inner_definitions = inner_definitions
  end

  # @return [Pro]
  #
  # @api private
  # @since 0.5.0
  def call
    # TODO: add memoization abilities
    inner_definitions.call
  end

  private

  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  attr_reader :inner_definitions
end
