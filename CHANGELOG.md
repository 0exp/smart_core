# Changelog
All notable changes to this project will be documented in this file.

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
