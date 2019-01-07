# frozen_string_literal: true

class SmartCore::Operation
  # @api private
  # @since 0.2.0
  module AttributeDSL
    class << self
      # @param base_klass [Class]
      # @return [void]
      #
      # @api private
      # @since 0.2.0
      def extended(base_klass)
        base_klass.instance_variable_set(:@__attributes__, AttributeSet.new)

        base_klass.singleton_class.prepend(Module.new do
          # @param child_klass [Class]
          # @return [void]
          #
          # @api private
          # @since 0.2.0
          def inherited(child_klass)
            child_klass.instance_variable_set(:__attributes__, AttributeSet.new)
            child_klass.__attributes__.concat(__attributes__)
            super(child_klass)
          end
        end)
      end
    end

    # @param attribute_name [String, Symbol]
    # @return [void]
    #
    # @api public
    # @since 0.2.0
    def attribute(attribute_name)
      attribute = SmartCore::Operation::Attribute.new(attribute_name)
      attributes << attribute
      attr_reader attribute.name
    end

    # @return [SmartCore::Operation::AttributeSet]
    #
    # @api private
    # @since 0.2.0
    def __attributes__
      @__attributes__
    end
  end
end
