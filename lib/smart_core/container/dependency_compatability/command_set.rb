# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  class CommandSet < Abstract
    class << self
      # @param command_set [SmartCore::Container::CommandSet]
      # @param dependency_command [SmartCore::Container::Commands::Register]
      # @return [void]
      #
      # @raise [SmartCore::Container::NamespaceOverlapError]
      #
      # @api private
      # @since 0.5.0
      def prevent_namespace_overlap!(command_set, dependency_command)
        raise(
          SmartCore::Container::NamespaceOverlapError,
          "Trying to overlap already registered :#{dependency_command.dependency_name} " \
          "namespace with :#{dependency_command.dependency_name} dependency!"
        ) if potential_namespace_overlap?(command_set, dependency_command)
      end

      # @param command_set [SmartCore::Container::CommandSet]
      # @param namespace_command [SmartCore::Container::Commands::Namespace]
      # @return [void]
      #
      # @raise [SmartCore::Container::DependencyOverlapError]
      #
      # @api private
      # @since 0.5.0
      def prevent_dependency_overlap!(command_set, namespace_command)
        raise(
          SmartCore::Container::DependencyOverlapError,
          "Trying to overlap already registered :#{namespace_command.namespace_name} " \
          "dependency with :#{namespace_command.namespace_name} namespace!"
        ) if potential_dependency_overlap?(command_set, namespace_command)
      end

      # @param command_set [SmartCore::Container::CommandSet]
      # @param dependency_command [SmartCore::Container::Commands::Register]
      # @return [Boolean]
      #
      # @api private
      # @since 0.5.0
      def potential_namespace_overlap?(command_set, dependency_command)
        command_set.any? do |command|
          next unless command.is_a?(SmartCore::Container::Command::Namespace)
          command.namespace_name == dependency_command.dependency_name
        end
      end

      # @param command_set [SmartCore::Container::CommandSet]
      # @param namespace_command [SmartCore::Container::Commands::Namespace]
      # @return [Boolean]
      #
      # @api private
      # @since 0.5.0
      def potential_dependency_overlap?(command_set, namespace_command)
        command_set.any? do |command|
          next unless command.is_a?(SmartCore::Container::Command::Register)
          command.dependency_name == command.namespace_name
        end
      end
    end
  end
end
