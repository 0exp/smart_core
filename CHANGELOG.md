# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased]
### Added
- **Initializer**
- **Dependency Container**
- **Dependency Injector**

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
