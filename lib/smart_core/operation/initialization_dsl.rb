# frozen_string_literal: true

class SmartCore::Operation
  # @api private
  # @since 0.2.0
  module InitializationDSL
    class << self
      # @param base_klass [Class]
      # @return [void]
      #
      # @api private
      # @since 0.2.0
      def included(base_klass)
        base_klass.extend(DSLMethods)
        base_klass.prepend(InitializationMethods)

        base_klass.instance_variable_set(:@__params__, AttributeSet.new)
        base_klass.instance_variable_set(:@__options__, AttributeSet.new)

        base_klass.singleton_class.prepend(Module.new do
          # @param child_klass [Class]
          # @return [void]
          #
          # @api private
          # @since 0.2.0
          def inherited(child_klass)
            child_klass.instance_variable_set(:@__params__, AttributeSet.new)
            child_klass.instance_variable_set(:@__options__, AttributeSet.new)

            child_klass.__params__.concat(__params__)
            child_klass.__options__.concat(__options__)

            super(child_klass)
          end
        end)
      end
    end

    # @api private
    # @since 0.2.0
    module InitializationMethods
      # @param attributes [Any]
      # @param options [Hash<Symbol,Any>]
      # @param block [Proc]
      # @return [Any]
      #
      # @api public
      # @since 0.2.0
      def new(*attributes, **options, &block)
        allocate.tap do |object|
          InstanceBuilder.call(object, self, attributes, options, block)
        end
      end
    end

    # @api private
    # @since 0.2.0
    module DSLMethods
      # @param param_name [String, Symbol]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def param(param_name)
        parameter = SmartCore::Operation::Attribute.new(param_name)
        __params__ << parameter
        attr_reader parameter.name
      end

      def option(option_name)
        option = SmartCore::Operation::Attribute.new(option_name)
        __options__ << option
        attr_reader option.name
      end

      # @return [SmartCore::Operation::AttributeSet]
      #
      # @api private
      # @since 0.2.0
      def __params__
        @__params__
      end

      # @return [SmartCore::Operation::AttributeSet]
      #
      # @api private
      # @since 0.2.0
      def __options__
        @__options__
      end
    end
  end
end
