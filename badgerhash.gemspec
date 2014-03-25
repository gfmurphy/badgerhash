# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'badgerhash/version'

Gem::Specification.new do |spec|
  spec.name          = "badgerhash"
  spec.version       = Badgerhash::VERSION
  spec.authors       = ["George F. Murphy"]
  spec.email         = ["gmurphy@epublishing.com"]
  spec.summary       = "Parse XML as IO into hash using badgerfish convention."
  spec.homepage      = "http://github.com/gfmurphy/badgerhash"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1.1"
end
