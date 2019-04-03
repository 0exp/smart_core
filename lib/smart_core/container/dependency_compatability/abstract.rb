# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::DependencyCompatability::Abstract
  class << self
    # @param dependency_root [Any]
    # @param dependency [Any]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def prevent_namespace_overlap!(dependency_root, dependency)
      raise NoMethodError
    end

    # @param dependency_root [Any]
    # @param namespace [Any]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def prevent_dependency_overlap!(dependency_root, namespace)
      raise NoMethodError
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
