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

- **Operation Object** (aka `Service Object`) (`SmartCore::Operation`)
  - attribute definition DSL (`param`, `option`, `params`, `options`);
  - yieldable result object abstraction (`Success`, `Failure`);
  - yieldable `#call` (and `.call`);
  - inheritance works as expected `:)`;
  - no dependencies;

- **Validation Object** (`SmartCore::Validator`)
  - support for nested validations;
  - inheritance works as expected `:)`;
  - command-style DSL;
  - thread-safe;
  - no dependencies;

---

#### Validation Object

```ruby
class Validator < SmartCore::Validator
  # soon...
end
```

#### Operation Object

```ruby
class Service < SmartCore::Operation
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
