# frozen_string_literal: true

module SmartCore::Initializer
  # @api private
  # @since 0.5.0
  module InitializationDSL
    class << self
      # @param base_klass [Class]
      # @return [void]
      #
      # @api private
      # @since 0.5.0
      def included(base_klass) # rubocop:disable Metrics/AbcSize
        # rubocop:disable Metrics/LineLength
        base_klass.instance_variable_set(:@__initialization_extension_definer__, ExtensionDefiner.new(base_klass))
        base_klass.instance_variable_set(:@__initialization_extensions__, ExtensionSet.new)
        base_klass.instance_variable_set(:@__attr_definer__, AttributeDefiner.new(base_klass))
        base_klass.instance_variable_set(:@__params__, AttributeSet.new)
        base_klass.instance_variable_set(:@__options__, AttributeSet.new)
        # rubocop:enable Metrics/LineLength

        base_klass.extend(ClassMethods)
        base_klass.extend(DSLMethods)
        base_klass.singleton_class.prepend(InitializationMethods)

        base_klass.singleton_class.prepend(Module.new do
          # @param child_klass [Class]
          # @return [void]
          #
          # @api private
          # @since 0.5.0
          def inherited(child_klass) # rubocop:disable Metrics/AbcSize
            # rubocop:disable Metrics/LineLength
            child_klass.instance_variable_set(:@__initialization_extension_definer__, ExtensionDefiner.new(child_klass))
            child_klass.instance_variable_set(:@__initialization_extensions__, ExtensionSet.new)
            child_klass.instance_variable_set(:@__attr_definer__, AttributeDefiner.new(child_klass))
            child_klass.instance_variable_set(:@__params__, AttributeSet.new)
            child_klass.instance_variable_set(:@__options__, AttributeSet.new)
            # rubocop:enable Metrics/LineLength

            child_klass.singleton_class.prepend(InitializationMethods)

            child_klass.__initialization_extensions__.concat(__initialization_extensions__)
            child_klass.__params__.concat(__params__)
            child_klass.__options__.concat(__options__)

            super(child_klass)
          end
        end)
      end
    end

    # @api private
    # @since 0.5.0
    module InitializationMethods
      # @param parameters [Any]
      # @param options [Hash<Symbol,Any>]
      # @return [Any]
      #
      # @api public
      # @since 0.5.0
      def new(*parameters, **options)
        allocate.tap do |object|
          InstanceBuilder.call(object, self, parameters, options)
        end
      end
    end

    # @api private
    # @since 0.5.0
    module ClassMethods
      # @return [SmartCore::Initializer::AttributeSet]
      #
      # @api private
      # @since 0.5.0
      def __params__
        @__params__
      end

      # @return [SmartCore::Initializer::AttributeSet]
      #
      # @api private
      # @since 0.5.0
      def __options__
        @__options__
      end

      # @return [SmartCore::Initializer::AttributeDefiner]
      #
      # @api private
      # @since 0.5.0
      def __attr_definer__
        @__attr_definer__
      end

      # @return [SmartCore::Initializer::ExtensionSet]
      #
      # @api private
      # @since 0.5.0
      def __initialization_extensions__
        @__initialization_extensions__
      end

      # @return [SmartCore::Initializer::ExtensionDefiner]
      #
      # @api private
      # @since 0.5.0
      def __initialization_extension_definer__
        @__initialization_extension_definer__
      end
    end

    # @api private
    # @since 0.5.0
    module DSLMethods
      # @param param_name [String, Symbol]
      # @param options [Hash<Symbol,Any>]
      # @return [void]
      #
      # @api public
      # @since 0.5.0
      def param(param_name, type = :__any__, **options)
        __attr_definer__.define_param(param_name, type, **options)
      end

      # @param param_names [Array<String, Symbol>]
      # @return [void]
      #
      # @api public
      # @since 0.5.0
      def params(*param_names)
        __attr_definer__.define_params(*param_names)
      end

      # @param option_name [String, Symbol]
      # @param options [Hash<Symbol,Any>]
      # @return [void]
      #
      # @api public
      # @since 0.5.0
      def option(option_name, type = :__any__, **options)
        __attr_definer__.define_option(option_name, type, **options)
      end

      # @param option_names [Array<String, Symbol>]
      # @return [void]
      #
      # @api public
      # @since 0.5.0
      def options(*option_names)
        __attr_definer__.define_options(*option_names)
      end

      # @param block [Proc]
      # @return [void]
      #
      # @api public
      # @since 0.5.0
      def extend_initialization_flow(&block)
        __initialization_extension_definer__.append_extension(block)
      end
    end
  end
end
