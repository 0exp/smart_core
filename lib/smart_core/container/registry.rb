# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::Registry
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize
    @access_lock = Mutex.new
    @registry = {}
  end

  # @param name [String, Symbol]
  # @param registry_definitions [Proc]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def namespace(name, registry_definitions)
    thread_safe do
      dependency_name = Compatability.indifferently_accessable_dependency_name(name)

      if has_dependency?(dependency_name)
        existing_dependency = registry.fetch(dependency_name)
      else

      end
    end
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
  # @return [SmartCore::Container::Registry::Dependency]
  #
  # @api private
  # @since 0.5.0
  def resolve(dependency_name)
    thread_safe do
      dependency_key = Compatability.indifferently_accessable_dependency_name(dependency_name)

      registry.fetch(dependency_key)
    end
  end

  private

  # @return [Hash<Symbol,Any>]
  #
  # @api private
  # @since 0.5.0
  attr_reader :registry

  # @Param dependency_name [String, Symbol]
  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def has_dependency?(dependency_name)
    registry.key?(dependency_name)
  end

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def thread_safe
    @access_lock.synchronize(&block)
  end
end
