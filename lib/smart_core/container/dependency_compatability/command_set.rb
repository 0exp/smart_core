# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  class CommandSet < Abstract
    class << self
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
