# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'awstool/version'

Gem::Specification.new do |spec|
  spec.name          = "awstool"
  spec.version       = Awstools::VERSION
  spec.authors       = ["Nick Burgess"]
  spec.email         = ["nburgess@uchicago.edu"]

  spec.summary       = %q{Tool for launching and configuring AWS EC2 instances.}
  spec.description   = %q{This will launch new instances, set up dns via route53, install puppet, and set facts.}
  spec.homepage      = "https://github.com/nburg/awstools"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_runtime_dependency "fog", '~> 1.38.0'
end
