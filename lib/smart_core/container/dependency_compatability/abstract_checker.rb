# frozen_string_literal: true

# @api private
# @since 0.5.0
class SmartCore::Container::DependencyCompatability::AbstractChecker
  # @param dependency_root [Any]
  # @return [void]
  #
  # @api private
  # @since 0.5.0
  def initialize(dependency_root)
    @dependency_root = dependency_root
  end

  # @param dependency [SmartCore::Container::Dependency]
  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def potential_namespace_overlap?(dependency)
    raise NoMethodError
  end

  # @param namespace [SmartCore::Container::Namespace]
  # @return [Boolean]
  #
  # @api private
  # @since 0.5.0
  def potential_dependency_overlap?(namespace)
    raise NoMethodError
  end

  private

  # @return [Any]
  attr_reader :dependency_root
end
