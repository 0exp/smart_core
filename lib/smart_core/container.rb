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
  require_relative 'container/namespace'
  require_relative 'container/registry'
  require_relative 'container/definition_dsl'
  require_relative 'container/registry_builder'
  require_relative 'container/dependency_resolver'
  require_relative 'container/mixin'

  # @since 0.5.0
  include DefinitionDSL

  # @return [void]
  #
  # @api public
  # @since 0.5.0
  def initialize
    @registry = RegistryBuilder.build(self.class.__commands__)
  end

  # @param dependency_name [String, Symbol]
  # @param dependency_definition [Block]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def register(dependency_name, &dependency_definition)
    registry.register(dependency_name, &dependency_definition)
  end

  # @param namespace_name [String, Symbol]
  # @param dependency_definitions [Block]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def namespace(namespace_name, &dependency_definitions)
    registry.namespace(namespace_name, &dependency_definitions)
  end

  # @param dependency_path [String, Symbol]
  # @return [Any]
  #
  # @api public
  # @since 0.5.0
  def resolve(dependency_path)
    DependencyResolver.resolve(registry, dependency_path)
  end

  private

  # @return [SmartCore::Container::Registry]
  #
  # @api private
  # @since 0.5.0
  attr_reader :registry
end
