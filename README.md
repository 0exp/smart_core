# SmartCore &middot; [![Gem Version](https://badge.fury.io/rb/smart_core.svg)](https://badge.fury.io/rb/smart_core) [![Build Status](https://travis-ci.org/0exp/smart_core.svg?branch=master)](https://travis-ci.org/0exp/smart_core) [![Coverage Status](https://coveralls.io/repos/github/0exp/smart_core/badge.svg?branch=master)](https://coveralls.io/github/0exp/smart_core?branch=master)

In active development.

---

## Installation

```ruby
gem 'smart_core'
```

```shell
bundle install
# --- or ---
gem install smart_core
```

```ruby
require 'smart_core'
```

---

#### Completed abstractions:

- [**Schema**](#schema) (`SmartCore::Container`) (parameters structure checker)
  - required and optional parameters;
  - strict and non-strict modes;
  - simple definition dsl;
  - instance implementation;
  - mixin implementation;
  - thread-safe;
  - no external dependencies;
- [**Dependency Container**](#dependency-container) (`SmartCore::Container`)
  - realized as an instance;
  - an ability to use as a mixin `SmartCore::Container::Mixin` (shared container instance between class and it's instances);
  - inheritance works as expected `:)`;
  - thread safe;
  - no external dependencies;
- [**Dependency Injection**](#dependency-injection) (`SmartCore::Injector`)
  - wowowowowowowow :O
- [**Initialization DSL**](#initialization-dsl) (`SmartCore::Initializer`)
  - defines smart and robust constructors `:)`;
  - attribute definition DSL (`param`, `option`, `params`, `options`);
  - support for type annotations and type checking;
  - support for positional attributes;
  - support for options with default values;
  - support for visibility declarations for attribute readers;
  - exceptional behaviour;
  - no external dependencies;
- [**Operation Object**](#operation-object) (aka `Service Object`) (`SmartCore::Operation`)
  - attribute definition DSL (`param`, `option`, `params`, `options`);
  - yieldable result object abstraction (`Success`, `Failure`, `Fatal`, `#success?`, `#failure?`, `#fatal?`);
  - yieldable `#call` (and `.call`);
  - inheritance works as expected `:)`;
  - no external dependencies;
- [**Validation Object**](#validation-object) (`SmartCore::Validator`)
  - support for nested validations;
  - inheritance works as expected `:)`;
  - `#error` - adds an error code;
  - `#fatal` - adds an error code and stops the current method execution flow;
  - command-style DSL;
  - thread-safe;
  - no external dependencies;

---

#### Dependency Container

```ruby
class Container < SmartCore::Container
  namespace :serialization do
    register(:json) { JsonSerializer }
    register(:hash) { HashSerializer }
  end

  register(:random) { SecureRandom }

  # soon...
end

container = Container.new
container.resolve(:serialization).resolve(:json) # => JsonSerializer
container.register(:random) { Random.new }
container.resolve(:random) # => #<Random:0x00007f89d486b680>

# soon: container.resolve('serialization.json')
# soon: container.register('serialization.json') { ... }

class SimpleService
  include SmartCore::Container::Mixin

  define_dependencies do
    register(:randomizer) { Random.new }
  end

  def call
    container.resolve(:randomizer).rand
  end
end

SimpleService.container # => #<SmartCore::Container:0x1111111111111111>
service = SimpleService.new
service.container # => (same) #<SmartCore::Container:0x1111111111111111>

service.call # => 0.5397305740865393
```

#### Initialization DSL

```ruby
class Structure
  include SmartCore::Initializer

  param :password, :string # NOTE: type is optional
  param :nickname, :string, privacy: :protected

  option :admin, :boolean, default: false, privacy: :private
  option :timestamp, default: -> { Time.now }

  # soon...
end

Structure.new('test123', '0exp', admin: true)

SmartCore::Initializer.register_type(:time) do |value|
  value.is_a?(Time) || value.is_a?(Date)
end

class AnotherStructure
  include SmartCore::Initializer

  param :registration_time, :time
end

AnotherStructure.new('no_time') # => SmartCore::Initializer::ArgumentError
```

#### Operation Object

```ruby
class Service < SmartCore::Operation
  # soon...
end
```

#### Validation Object

```ruby
class Validator < SmartCore::Validator
  # soon...
end
```

---

## Contributing

- Fork it ( https://github.com/0exp/smart_core/fork )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am 'Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
