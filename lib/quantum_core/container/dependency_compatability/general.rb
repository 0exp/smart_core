# frozen_string_literal: true

# @api private
# @since 0.1.0
module QuantumCore::Container::DependencyCompatability::General
  # @param context [Class<QuantumCore::Container>, QuantumCore::Container::Registry]
  # @param dependency_name [String, Symbol]
  # @return [void]
  #
  # @raise [QuantumCore::Container::DependencyOverNamespaceOverlapError]
  #
  # @api private
  # @since 0.1.0
  def prevent_namespace_overlap!(context, dependency_name)
    raise(
      QuantumCore::Container::DependencyOverNamespaceOverlapError,
      "Trying to overlap already registered '#{dependency_name}' namespace " \
      "with '#{dependency_name}' dependency!"
    ) if potential_namespace_overlap?(context, dependency_name)
  end

  # @param context [Class<QuantumCore::Container>, QuantumCore::Container::Registry]
  # @param namespace_name [String, Symbol]
  # @return [void]
  #
  # @raise [QuantumCore::Container::NamespaceOverDependencyOverlapError]
  #
  # @api private
  # @since 0.1.0
  def prevent_dependency_overlap!(context, namespace_name)
    raise(
      QuantumCore::Container::NamespaceOverDependencyOverlapError,
      "Trying to overlap already registered '#{namespace_name}' dependency " \
      "with '#{namespace_name}' namespace!"
    ) if potential_dependency_overlap?(context, namespace_name)
  end

  # @param context [Class<QuantumCore::Container>, QuantumCore::Container::Registry]
  # @param dependency_name [String, Symbol]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def potential_namespace_overlap?(context, dependency_name)
    raise NoMethodError
  end

  # @param context [Class<QuantumCore::Container>, QuantumCore::Container::Registry]
  # @param namespace_name [String, Symbol]
  # @return [Boolean]
  #
  # @api private
  # @since 0.1.0
  def potential_dependency_overlap?(context, namespace_name)
    raise NoMethodError
  end
end
