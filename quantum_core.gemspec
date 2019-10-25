# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative 'lib/quantum_core/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.3.8'

  spec.name        = 'quantum_core'
  spec.version     = QuantumCore::VERSION
  spec.authors     = ['Rustam Ibragimov']
  spec.email       = ['iamdaiver@icloud.com']

  spec.summary     = '(in active development) A set of common abstractions'
  spec.description = '(in active development) A set of common abstractions'
  spec.homepage    = 'https://github.com/0exp/smart_core'
  spec.license     = 'MIT'

  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  end

  spec.add_development_dependency 'simplecov',        '~> 0.17'
  spec.add_development_dependency 'armitage-rubocop', '~> 0.75'
  spec.add_development_dependency 'rspec',            '~> 3.8'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
end
