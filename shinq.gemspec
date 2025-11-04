# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "shinq"
  spec.version       = '1.3.0'
  spec.authors       = ["Ryoichi SEKIGUCHI"]
  spec.email         = ["ryopeko@gmail.com"]
  spec.summary       = %q{Worker and enqueuer for Q4M using the interface of ActiveJob.}
  spec.homepage      = "https://github.com/ryopeko/shinq"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "tapp"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-mocks"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "trilogy"
  spec.add_development_dependency "mysql2"

  spec.add_dependency "sql-maker", ">= 0.0.4", "< 2"
  spec.add_dependency 'serverengine', ">= 1.5.9", "< 3"

  spec.add_dependency "activesupport", ">= 4.2.0"
  spec.add_dependency "activejob", ">= 4.2.0"
end
