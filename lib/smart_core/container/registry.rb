# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Registry
  require_relative 'registry/dependency'
  require_relative 'registry/compatability'

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :registry

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize
    @access_lock = Mutex.new
    @registry = {}
  end

  # @param dependency_name [String, Symbol]
  # @param dependency [Proc, #call]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def register(dependency_name, dependency)
    thread_safe do
      dependency = Compatability.indifferently_accessable_dependency(dependency)
      dependency_key = Compatability.indifferently_accessable_dependency_name(dependency_name)

      registry[dependency_key] = dependency
    end
  end

  # @param dependency_name [String, Symbol]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def resolve(dependency_name)
    thread_safe do
      dependency_key = Compatability.indifferently_accessable_dependency_name(dependency_name)
      dependency = registry.fetch(dependency_key)

      dependency.call
    end
  end

  private

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def thread_safe
    @access_lock.synchronize(&block)
  end
end
