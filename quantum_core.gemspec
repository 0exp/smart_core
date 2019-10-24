lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "quantum_core/version"

Gem::Specification.new do |spec|
  spec.name          = "quantum_core"
  spec.version       = QuantumCore::VERSION
  spec.authors       = ["Rustam Ibragimov"]
  spec.email         = ["iamdaiver@gmail.com"]

  spec.summary       = "Soon"
  spec.description   = "Soon"
  spec.homepage      = "http://github.com/0exp/quantum_core"
  spec.license       = "MIT"

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
