# frozen_string_literal: true

class SmartCore::Container
  # @api public
  # @since 0.5.0
  Error = Class.new(SmartCore::Error)

  # @api public
  # @since 0.5.0
  ArgumentError = Class.new(SmartCore::ArgumentError)

  # @api public
  # @since 0.5.0
  NamespaceOverlapError = Class.new(Error)

  # @api public
  # @since 0.5.0
  DependencyOverlapError = Class.new(Error)

  # @api public
  # @since 0.5.0
  UnexistentDependencyError = Class.new(Error)

  # @api public
  # @since 0.1.0
  FrozenRegistryError = begin # rubocop:disable Naming/ConstantName
    # :nocov:
    if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('2.5.0')
      Class.new(::FrozenError)
    else
      Class.new(::RuntimeError)
    end
    # :nocov:
  end
end
