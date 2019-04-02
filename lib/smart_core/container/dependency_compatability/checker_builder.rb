# frozen_string_literal: true

module SmartCore::Container::DependencyCompatability
  # @api private
  # @since 0.5.0
  module CheckerBuilder
    class << self
      # @param dependency_tree [SmartCore::Container::Registry, SmartCore::Container::CommandSet]
      # @raise [SmartCore::Container::IncompatibleDependencyTree]
      # @return [SmartCore::Container::DependencyCompatability::AbstrctChecker]
      #
      # @api private
      # @since 0.5.0
      def build(dependency_tree)
        case dependency_tree
        when SmartCore::Container::Registry   then build_for_command(dependency_tree)
        when SmartCore::Container::CommandSet then build_for_registry(dependency_tree)
        else
          raise IncompatibleDependencyTree
        end
      end

      private

      # @param command_set [SmartCore::Container::CommandSet]
      # @return [SmartCore::Container::DependencyCompatability::CommandChecker]
      #
      # @api private
      # @since 0.5.0
      def build_for_command(command_set)
        CommandChecker.new(command_set)
      end

      # @param registry [SmartCore::Container::Registry]
      # @return [SmartCore::Container::DependencyCompatability::RegistryChecker]
      #
      # @api private
      # @since 0.5.0
      def build_for_registry(registry)
        RegistryChecker.new(registry)
      end
    end
  end
end
