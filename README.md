# SmartCore &middot; [![Gem Version](https://badge.fury.io/rb/smart_core.svg)](https://badge.fury.io/rb/smart_core) [![Build Status](https://travis-ci.org/0exp/smart_core.svg?branch=master)](https://travis-ci.org/0exp/smart_core)

[ARCHIVED] The project is totally redesigned as [@smart-rb](https://github.com/smart-rb)


> Meetup Slides: [link](docs/SmartCore.pdf)

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

- Service Object (Operation, Functional Object);
- IoC Container (Dependency Container);
- Initializer (DSL);
- Validator (Validation Layer);

---

#### Roadmap

- Value Object (`SmartCore::ValueObject` (`DTO`) (truely immutable and comparable objects 😈));
- Schema Structure Validator (`SmartCore::Schema`);
- Saga (`SmartCore::Saga`);
- External Type System (`SmartCore::Types`);
  - Suport for **Interface Type Checking** (**Duck**-typing checker 🤔);
- Step-like execution behavior for `SmartCore::Operation` (`.step`, `SmartCore::Railway`);
- Automatic result instantiation and handling for `SmartCore::Operation`;

---

## Contributing

- Fork it ( https://github.com/0exp/smart_core/fork )
- Create your feature branch (`git checkout -b feature/my-new-feature`)
- Commit your changes (`git commit -am '[feature_context] Add some feature'`)
- Push to the branch (`git push origin feature/my-new-feature`)
- Create new Pull Request

## License

Released under MIT License.

## Authors

[Rustam Ibragimov](https://github.com/0exp)
