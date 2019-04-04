# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::DependencyCompatability::Abstract
  class << self
    # @param dependency_root [Any]
    # @param dependency_name [String]
    # @return [void]
    #
    # @raise [SmartCore::Container::NamespaceOverlapError]
    #
    # @api private
    # @since 0.5.0
    def prevent_namespace_overlap!(dependency_root, dependency_name)
      raise(
        SmartCore::Container::NamespaceOverlapError,
        "Trying to overlap already registered :#{dependency_name} " \
        "namespace with :#{dependency_name} dependency!"
      ) if potential_namespace_overlap?(dependency_root, dependency_name)
    end

    # @param dependency_root [Any]
    # @param namespace_name [String]
    # @return [void]
    #
    # @raise [SmartCore::Container::DependencyOverlapError]
    #
    # @api private
    # @since 0.5.0
    def prevent_dependency_overlap!(dependency_root, namespace_name)
      raise(
        SmartCore::Container::DependencyOverlapError,
        "Trying to overlap already registered :#{namespace_name} " \
        "dependency with :#{namespace_name} namespace!"
      ) if potential_dependency_overlap?(dependency_root, namespace_name)
    end

    # @param dependency_root [Any]
    # @param dependency [Any]
    # @return [Boolean]
    #
    # @api private
    # @since 0.5.0
    def potential_namespace_overlap?(dependency_root, dependency)
      raise NoMethodError
    end

    # @param dependency_root [Any]
    # @param namespace [Any]
    # @return [Boolean]
    #
    # @api private
    # @since 0.5.0
    def potential_dependency_overlap?(dependency_root, namespace)
      raise NoMethodError
    end
  end
end
