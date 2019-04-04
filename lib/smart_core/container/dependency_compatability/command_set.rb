# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  class CommandSet < Abstract
    class << self
      # @param command_set [SmartCore::Container::CommandSet]
      # @param dependency_name [String]
      # @return [Boolean]
      #
      # @api private
      # @since 0.5.0
      def potential_namespace_overlap?(command_set, dependency_name)
        command_set.any? do |command|
          next unless command.is_a?(SmartCore::Container::Commands::Namespace)
          command.namespace_name == dependency_name
        end
      end

      # @param command_set [SmartCore::Container::CommandSet]
      # @param namespace_name [String]
      # @return [Boolean]
      #
      # @api private
      # @since 0.5.0
      def potential_dependency_overlap?(command_set, namespace_name)
        command_set.any? do |command|
          next unless command.is_a?(SmartCore::Container::Commands::Register)
          command.dependency_name == namespace_name
        end
      end
    end
  end
end
