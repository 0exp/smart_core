# frozen_string_literal: true

# @api public
# @since 0.2.0
class SmartCore::Operation::Success < SmartCore::Operation::Result
  # @param result_options [Hash<Symbol, Any>]
  # @return [void]
  #
  # @api public
  # @since 0.2.0
  def initialize(**result_options)
    super(**result_options)

    result_options.each_key do |result_name|
      # TODO: fail if result_name intersects with API method names
      define_singleton_method(result_name) do
        @__result_options__[result_name]
      end
    end
  end

  # @return [Boolean]
  #
  # @api public
  # @since 0.2.0
  def success?
    true
  end
end
