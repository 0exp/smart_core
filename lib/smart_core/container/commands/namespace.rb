# frozen_string_literal: true

module SmartCore::Container::Commands
  # @api private
  # @since 0.5.0
  class Namespace < Base
    # @param name [String, Symbol]
    # @param dependency_definitions [Proc]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def initialize(name, dependency_definitions)
      @name = name
      @dependency_definitions = dependency_definitions
    end

    # @param container [SmartCore::Container]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def call(container)
      # TODO: падаем, если перекрываем существующую зависомость
      # TODO: расширяем нэймспэйс, если пытается перезарегать существующий неймспейс
      container.register(name, dependency_definitions)
    end

    private

    # @return [String, Symbol]
    #
    # @api private
    # @since 0.5.0
    attr_reader :name

    # @return [Proc]
    #
    # @api private
    # @since 0.5.0
    attr_reader :dependency_definitions
  end
end
