# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::DependencyBuilder
  class << self
    # @param dependency_definition [Proc]
    # @option memoize [Boolean]
    # @return [SmartCore::Container::Dependency, SmartCore::Container::MemoizedDependency]
    #
    # @api private
    # @since 0.5.0
    def build(dependency_definition, memoize: false, **options)
      # @todo: raise an error if memoize is not a boolean

      if memoize
        build_memoized_dependency(dependency_definition, **options)
      else
        build_dependency(dependency_definition, **options)
      end
    end

    private

    # @param dependency_definition [Proc]
    # @param options [Hash<Symbol,Any>]
    # @return [SmartCore::Container::MemoizedDependency]
    #
    # @api private
    # @since 0.5.0
    def build_memoized_dependency(dependency_definition, **options)
      SmartCore::Container::MemoizedDependency.new(dependency_definition, **options)
    end

    # @param dependency_definition [Proc]
    # @param options [Hash<Symbol,Any>]
    # @return [SmartCore::Container::Dependency]
    #
    # @api private
    # @since 0.5.0
    def build_dependency(dependency_definition, **options)
      SmartCore::Container::Dependency.new(dependency_definition, **options)
    end
  end
end
