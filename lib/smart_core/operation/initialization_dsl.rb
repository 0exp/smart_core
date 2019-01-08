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
      def included(base_klass) # rubocop:disable Metrics/AbcSize
        base_klass.extend(DSLMethods)
        base_klass.singleton_class.prepend(InitializationMethods)

        base_klass.instance_variable_set(:@__params__, AttributeSet.new)
        base_klass.instance_variable_set(:@__options__, AttributeSet.new)

        base_klass.singleton_class.prepend(Module.new do
          # @param child_klass [Class]
          # @return [void]
          #
          # @api private
          # @since 0.2.0
          def inherited(child_klass)
            child_klass.singleton_class.prepend(InitializationMethods)

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
      # @param parameters [Any]
      # @param options [Hash<Symbol,Any>]
      # @param block [Proc]
      # @return [Any]
      #
      # @api public
      # @since 0.2.0
      def new(*parameters, **options, &block)
        allocate.tap do |object|
          InstanceBuilder.call(object, self, parameters, options, block)
        end
      end
    end

    # @api private
    # @since 0.2.0
    module DSLMethods
      # TODO: support for .params(*parameter_names) api
      # TODO: support for .options(*options) api
      #   (or .options(**options) in { option_name => default_value, ... } attribute form)

      # @param param_name [String, Symbol]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def param(param_name) # TODO: падать, если уже есть опция с таким именем
        parameter = SmartCore::Operation::Attribute.new(param_name)
        __params__ << parameter
        attr_reader parameter.name
      end

      # @param option_name [String, Symbol]
      # @param options [Hash<Symbol,Any>]
      # @return [void]
      def option(option_name, **options) # TODO: падать, если уже есть параметр с таким именем
        option = SmartCore::Operation::Attribute.new(option_name, **options)
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
