# frozen_string_literal: true

# @api private
# @since 0.5.0
module SmartCore::Container::DependencyBuilder
  class << self
    # @param external_name [String]
    # @param dependency_definition [Proc]
    # @option memoize [Boolean]
    # @return [SmartCore::Container::Dependency, SmartCore::Container::MemoizedDependency]
    #
    # @api private
    # @since 0.5.0
    def build(external_name, dependency_definition, memoize: false, **options)
      # @todo: raise an error if memoize is not a boolean

      if memoize
        build_memoized_dependency(external_name, dependency_definition, **options)
      else
        build_dependency(external_name, dependency_definition, **options)
      end
    end

    private

    # @param external_name [String]
    # @param dependency_definition [Proc]
    # @param options [Hash<Symbol,Any>]
    # @return [SmartCore::Container::MemoizedDependency]
    #
    # @api private
    # @since 0.5.0
    def build_memoized_dependency(external_name, dependency_definition, **options)
      SmartCore::Container::MemoizedDependency.new(external_name, dependency_definition, **options)
    end

    # @param external_name [String]
    # @param dependency_definition [Proc]
    # @param options [Hash<Symbol,Any>]
    # @return [SmartCore::Container::Dependency]
    #
    # @api private
    # @since 0.5.0
    def build_dependency(external_name, dependency_definition, **options)
      SmartCore::Container::Dependency.new(external_name, dependency_definition, **options)
    end
  end
end
