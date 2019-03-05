# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Dependency
  # @param object [Any]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(object)
    @object = object
  end

  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def call
    # TODO: add memoization abilities
    object.call
  end

  private

  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  attr_reader :object
end
