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
      define_singleton_method(result_name) { @__result_options__[result_name] }
    end

    # TODO: фэйлиться, если ключ result_options'а совпадает с нативным аттр-ридером
    #   (с __result_options__ или с __result_attributes__)
  end
end
