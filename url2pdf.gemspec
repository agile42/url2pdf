# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'url2pdf/version'

Gem::Specification.new do |spec|
  spec.name          = "url2pdf"
  spec.version       = Url2pdf::VERSION
  spec.authors       = ["Nic Pillinger"]
  spec.email         = ["nic@lsf.io"]
  spec.summary       = %q{ URL => PDF }
  spec.description   = %q{ Client for LSF PDF service }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack", "~> 1.6"
  spec.add_dependency "httparty", "~> 0.13.3"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "guard", "~> 2.12"
  spec.add_development_dependency "guard-rspec", "~> 4.5"
end
