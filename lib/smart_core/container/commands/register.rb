# frozen_string_literal: true

module SmartCore::Container::Commands
  # @api private
  # @since 0.5.0
  class Register < Base
    # @param dependency_name [String, Symbol]
    # @param dependency [Proc, #call]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def initialize(dependency_name, dependency)
      @dependency_name = dependency_name
      @dependency = dependency
    end

    # @param container [SmartCore::Container]
    # @return [void]
    #
    # @api private
    # @since 0.5.0
    def call(container)
      # TODO: падаем, если перекрываем нэймспэйс
      # TODO: не падаем, если пытаемся перерзарегать существуюущую зависимость
      container.register(dependency_name, dependency)
    end

    private

    # @return [Proc, #call]
    #
    # @api private
    # @since 0.5.0
    attr_reader :dependency

    # @return [String, Symbol]
    #
    # @api private
    # @since 0.5.0
    attr_reader :dependency_name
  end
end
