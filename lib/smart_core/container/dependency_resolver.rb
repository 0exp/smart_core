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

      Route.build(dependency_path).tap do |route|
        route.each_with_index do |route_part, route_part_index|
          entity = entity.resolve(route_part)
          prevent_unfinished_resolving!(route, route_part, route_part_index, entity)
          entity = entity.reveal
        end
      end

      entity.reveal
    end

    private

    def extract

    end

    # @param route [SmartCore::Container::DependencyResolver::Route]
    # @param route_part [String]
    # @param route_part_index [Integer]
    # @param container_entity [SmartCore::Container::Entites::Base]
    # @return [void]
    #
    # @raise [SmartCore::Container::FetchError]
    #
    # @api private
    # @since 0.8.0
    def prevent_unfinished_resolving!(route, route_part, route_part_index, container_entity)
      if route.end?(route_part_index) && !container_entity.is_a?(SmartCore::Container::Entities::Dependency)
        binding.pry
        raise(
          SmartCore::Container::FetchError,
          "No registered dependency with \"#{route.path}\" path"
        )
      end

      if !route.end?(route_part_index) && container_entity.is_a?(SmartCore::Container::Entities::Dependency)
        raise(
          SmartCore::Container::FetchError,
          "Can not fetch dependency \"#{route.path}\" because \"#{route_part}\" is not a namespace"
        )
      end
    end
  end
end
