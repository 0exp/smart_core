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
      # TODO:
      #   - dry validation methods
      #   - dry factory methods

      # @param param_name [String, Symbol]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def param(param_name)
        parameter = SmartCore::Operation::Attribute.new(param_name)
        __prevent_intersection_with_option__(parameter)
        __append_param__(parameter)
      end

      # @param param_names [Array<String, Symbol>]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def params(*param_names)
        parameters = param_names.map do |param_name|
          SmartCore::Operation::Attribute.new(param_name).tap do |parameter|
            __prevent_intersection_with_option__(parameter)
          end
        end

        parameters.each { |parameter| __append_param__(parameter) }
      end

      # @param option_name [String, Symbol]
      # @param options [Hash<Symbol,Any>]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def option(option_name, **options)
        option = SmartCore::Operation::Attribute.new(option_name, **options)
        __prevent_intersection_with_param__(option)
        __append_option__(option)
      end

      # @param option_names [Array<String, Symbol>]
      # @return [void]
      #
      # @api public
      # @since 0.2.0
      def options(*option_names)
        options = option_names.map do |option_name|
          SmartCore::Operation::Attribute.new(option_name).tap do |option|
            __prevent_intersection_with_param__(option)
          end
        end

        options.each { |option| __append_option__(option) }
      end

      # @return [SmartCore::Operation::AttributeSet]
      #
      # @api private
      # @since 0.2.0
      def __params__
        @__params__
      end

      # @param parameter [SmartCore::Operation::Attribute]
      # @return [void]
      #
      # @api private
      # @since 0.2.0
      def __append_param__(parameter)
        __params__ << parameter
        attr_reader parameter.name
      end

      # @return [SmartCore::Operation::AttributeSet]
      #
      # @api private
      # @since 0.2.0
      def __options__
        @__options__
      end

      # @param option [SmartCore::Operation::Attribute]
      # @return [void]
      #
      # @api private
      # @since 0.2.0
      def __append_option__(option)
        __options__ << option
        attr_reader option.name
      end

      # @param option [SmartCore::Operation::Attribute]
      # @return [void]
      #
      # @raise [???]
      #
      # @api private
      # @since 0.2.0
      def __prevent_intersection_with_param__(option)
        # TODO: implement
      end

      # @param parameter [SmartCore::Operation::Attribute]
      # @return [void]
      #
      # @raise [???]
      #
      # @api private
      # @since 0.2.0
      def __prevent_intersection_with_option__(parameter)
        # TODO: implement
      end
    end
  end
end
