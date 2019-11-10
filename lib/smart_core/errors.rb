# frozen_string_literal: true

module SmartCore
  # @api public
  # @since 0.5.0
  Error = Class.new(StandardError)

  # @api public
  # @since 0.5.0
  ArgumentError = Class.new(::ArgumentError)

  # @api public
  # @since 0.5.0
  FrozenError = begin # rubocop:disable Naming/ConstantName
    # :nocov:
    if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.5.0')
      Class.new(::FrozenError)
    else
      Class.new(::RuntimeError)
    end
    # :nocov:
  end
end
