# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "shinq"
  spec.version       = '0.0.1.alpha1'
  spec.authors       = ["Ryoichi SEKIGUCHI"]
  spec.email         = ["ryopeko@gmail.com"]
  spec.summary       = %q{Worker and enqueuer for Q4M using the interface of ActiveJob.}
  spec.homepage      = "https://github.com/ryopeko/shinq"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_dependency "mysql2", "~> 0.3.16"
  spec.add_dependency "sql-maker", "~> 0.0.4"
  spec.add_dependency "activesupport", "~> 4.2.0.beta2"
end
