# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Dependency < SmartCore::Container::Entity
  # @param dependency_definition [Proc]
  # @param options [Hash<Symbol,Any>]
  # @return [void]
  #
  # @todo option list
  #
  # @api private
  # @since 0.5.0
  def initialize(external_name, dependency_definition, **options)
    @dependency_definition = dependency_definition
    @access_lock = Mutex.new
    super(external_name)
  end

  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def call
    thread_safe { dependency_definition.call }
  end

  private

  # @return [Proc]
  #
  # @api private
  # @since 0.5.0
  attr_reader :dependency_definition

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def thread_safe(&block)
    @access_lock.synchronize(&block)
  end
end
