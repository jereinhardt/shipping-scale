# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shipping_scale/version'

Gem::Specification.new do |spec|
  spec.name          = "shipping-scale"
  spec.version       = ShippingScale::VERSION
  spec.authors       = ["Josh Reinhardt"]
  spec.email         = ["joshua.e.reinhardt@gmail.com"]

  spec.summary       = %q{A simple Ruby API wrapper for the USPS price calculator API}
  spec.homepage      = "https://github.com/jereinhardt/shipping-scale"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "builder", "~> 2.0"
  spec.add_runtime_dependency 'nokogiri', '~> 1.4', '>= 1.4.1'
  spec.add_runtime_dependency 'typhoeus', '~> 0.1', '>= 0.1.18'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'dotenv', '~> 0'
end
