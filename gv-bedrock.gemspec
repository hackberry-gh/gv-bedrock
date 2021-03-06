# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gv/bedrock/version'

Gem::Specification.new do |spec|
  spec.name          = "gv-bedrock"
  spec.version       = GV::Bedrock::VERSION
  spec.authors       = ["Onur Uyar"]
  spec.email         = ["me@onuruyar.com"]
  spec.summary       = %q{Simple Rinda/Ring Network}
  spec.homepage      = "https://github.com/green-valley/gv-bedrock"
  spec.license       = "Unlicense"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest" 
  spec.add_dependency "gv-common"
end
