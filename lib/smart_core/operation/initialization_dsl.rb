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

        base_klass.instance_variable_set(:@__attr_definer__, AttributeDefiner.new(base_klass))
        base_klass.instance_variable_set(:@__params__, AttributeSet.new)
        base_klass.instance_variable_set(:@__options__, AttributeSet.new)
        base_klass.instance_variable_set(:@__steps__, StepSet.new)

        base_klass.singleton_class.prepend(Module.new do
          # @param child_klass [Class]
          # @return [void]
          #
          # @api private
          # @since 0.2.0
          def inherited(child_klass)
            child_klass.singleton_class.prepend(InitializationMethods)

            child_klass.instance_variable_set(:@__attr_definer__, AttributeDefiner.new(child_klass))
            child_klass.instance_variable_set(:@__params__, AttributeSet.new)
            child_klass.instance_variable_set(:@__options__, AttributeSet.new)
            child_klass.instance_variable_set(:@__steps__, StepSet.new)

            child_klass.__params__.concat(__params__)
            child_klass.__options__.concat(__options__)
            child_klass.__steps__.concat(__steps__)

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
      # @return [Any]
      #
      # @api public
      # @since 0.2.0
      def new(*parameters, **options)
        allocate.tap do |object|
          InstanceBuilder.call(object, self, parameters, options)
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
        __attr_definer__.define_param(param_name)
      end

      # @param param_names [Array<String, Symbol>]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def params(*param_names)
        __attr_definer__.define_params(*param_names)
      end

      # @param option_name [String, Symbol]
      # @param options [Hash<Symbol,Any>]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def option(option_name, **options)
        __attr_definer__.define_option(option_name, **options)
      end

      # @param option_names [Array<String, Symbol>]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def options(*option_names)
        __attr_definer__.define_options(*option_names)
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

      # @return [SmartCore::Operation::AttributeDefiner]
      #
      # @api private
      # @since 0.2.0
      def __attr_definer__
        @__attr_definer__
      end

      # @return [SmartCore::Operation::StepSet]
      #
      # @api private
      # @since 0.5.0
      def __steps__
        @__steps__
      end
    end
  end
end
