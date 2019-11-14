# frozen_string_literal: true

# @api private
# @since 0.7.0
module SmartCore::Container::DependencyResolver
  require_relative 'dependency_resolver/route'

  class << self
    # @param registry [SmartCore::Container::Registry]
    # @param dependency_path [String, Symbol]
    # @return [SmartCore::Container, Any]
    #
    # @see SmartCore::Container::Registry#resolve
    # @see SmartCore::Container::Entities::Namespace#resolve
    # @see SmartCore::Container::Entities::Dependency#resolve
    #
    # @api private
    # @since 0.7.0
    def resolve(registry, dependency_path)
      registry.resolve(dependency_path).reveal
    end

    # @param registry [SmartCore::Container::Registry]
    # @param dependency_path [String, Symbol]
    # @return [SmartCore::Container, Any]
    #
    # @see SmartCore::Container::Registry#resolve
    # @see SmartCore::Container::Entities::Namespace#resolve
    # @see SmartCore::Container::Entities::Dependency#resolve
    #
    # @api private
    # @since 0.8.0
    def fetch(registry, dependency_path)
      entity = registry

      Route.build(dependency_path).each do |cursor|
        entity = entity.fetch(cursor.path_part)
        raise SmartCore::Container::FetchError if cursor.last? && entity.is_a?(SmartCore::Container::Entities::Namespace)
        raise SmartCore::Container::FetchError if !cursor.last? && entity.is_a?(SmartCore::Container::Entities::Dependency)
        binding.pry
        entity = entity.reveal if entity.is_a?(SmartCore::Container::Entities::Namespace)
      end

      entity.reveal
    end
  end
end
