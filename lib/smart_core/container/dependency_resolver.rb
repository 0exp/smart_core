# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::DependencyResolver
  class << self
    # @param registry [SmartCore::Container::Registry]
    # @return [Any]
    #
    # @api private
    # @since 0.5.0
    def resolve(registry, dependency_path)
      registry.resolve(dependency_path).call
    end
  end
end
