# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ipsumizer/version'

Gem::Specification.new do |spec|
  spec.name          = "ipsumizer"
  spec.version       = Ipsumizer::VERSION
  spec.authors       = ["dfhoughton"]
  spec.email         = ["dfhoughton@gmail.com"]

  spec.summary       = 'Generate lorem ipsum text from a text sample.'
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/dfhoughton/ipsumizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "byebug", "~> 0"
end
