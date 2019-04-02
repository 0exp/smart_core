# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Entity
  # @return [String]
  #
  # @api private
  # @since 0.5.0
  attr_reader :external_name

  # @param external_name [String]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(external_name)
    @external_name = external_name
  end

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def call; end
end
