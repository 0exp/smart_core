# frozen_string_literal: true

# @api public
# @since 0.5.0
class SmartCore::Container
  require_relative 'container/exceptions'
  require_relative 'container/commands'
  require_relative 'container/command_set'
  require_relative 'container/key_guard'
  require_relative 'container/entity'
  require_relative 'container/dependency'
  require_relative 'container/memoized_dependency'
  require_relative 'container/namespace'
  require_relative 'container/dependency_builder'
  require_relative 'container/registry'
  require_relative 'container/definition_dsl'
  require_relative 'container/registry_builder'
  require_relative 'container/dependency_resolver'
  require_relative 'container/mixin'

  # TODO: support for #freeze!
  # TODO: container composition
  # TODO: #merge / #merge!

  # @since 0.5.0
  include DefinitionDSL

  # @return [void]
  #
  # @api public
  # @since 0.5.0
  def initialize
    build_registry
    @access_lock = Mutex.new
  end

  # @param dependency_name [String, Symbol]
  # @param options [Hash<Symbol,Any>]
  # @param dependency_definition [Block]
  # @return [void]
  #
  # @todo option list
  #
  # @api private
  # @since 0.5.0
  def register(dependency_name, **options, &dependency_definition)
    thread_safe do
      registry.register(dependency_name, **options, &dependency_definition)
    end
  end

  # @param namespace_name [String, Symbol]
  # @param dependency_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def namespace(namespace_name, &dependency_definitions)
    thread_safe do
      registry.namespace(namespace_name, &dependency_definitions)
    end
  end

  # @param dependency_path [String, Symbol]
  # @return [Any]
  #
  # @api public
  # @since 0.5.0
  def resolve(dependency_path)
    thread_safe do
      DependencyResolver.resolve(registry, dependency_path)
    end
  end

  # @return [void]
  #
  # @api public
  # @since 0.5.0
  def reload!
    thread_safe { build_registry }
  end

  private

  # @return [SmartCore::Container::Registry]
  #
  # @api private
  # @since 0.5.0
  attr_reader :registry

  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def build_registry
    @registry = RegistryBuilder.build(self.class.__commands__)
  end

  # @param block [Proc]
  # @return [Any]
  #
  # @api private
  # @since 0.5.0
  def thread_safe(&block)
    @access_lock.synchronize(&block)
  end
end
