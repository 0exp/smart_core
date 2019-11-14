# Changelog
All notable changes to this project will be documented in this file.

## [0.8.1] - 2019-11-4
- RubyGems re-push with fixed gem version;

## [0.8.0] - 2019-11-14
### Added
- [**SmartCore::Container**]
  - support for `dot-notation`;

### Changed
- [**SmartCore::Container**]
  - new `#resolve`: now supports only the dot-notated invokation style;
  - old `#resolve` renamed to `#fetch`;
  - added `#[](dependency_path)` - an alias for `#resolve`;

## [0.7.0] - 2019-11-10
### Changed
- `SmartCore::Operation::Custom` result type is renamed to `SmartCore::Operation::Callback`;
- Full reimplementation of `SmartCore::Container`;

## [0.6.0] - 2019-09-18
### Added
- New result type: `SmartCore::Operation::Custom` with custom logic provided as a proc;

## [0.5.2] - 2019-06-05
### Added
- Common Result Object interface (realized as a mixin (`SmartCore::Operation::ResultInterface`))

## [0.5.1] - 2019-06-04
### Added
- Support for `Symbol` type definition in `SmartCore::Initializer`

## [0.5.0] - 2019-06-02
### PRE-RELEASE

## [0.4.0] - 2019-01-27
### Added
- **Valdiator**
  - `#fatal` - an `#error`-like method that appends validation error code and stops current method execution flow;

## [0.3.0] - 2019-01-20
### Added
- **Operation**
  - New result object type: `Fatal` (`SmartCore::Operation::Fatal`, `#Fatal`)
    - stops the operation execution flow and returns
      `SmartCore::Operation::Fatal` result immidietly;
    - has `Failure`-like instantiation behavior and internal state (`#failure?`, `#fatal?`, `#errors`);

## [0.2.0] - 2019-01-20
### Added
- **Service object** abstraction (`SmartCore::Operation`);
- **Validator**
  - Support for `&block` attribute at object instantiation;

## [0.1.0] - 2019-01-05
### Added
- Validation object abstraction;
