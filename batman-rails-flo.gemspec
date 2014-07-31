# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'batman_rails_flo/version'

Gem::Specification.new do |spec|
  spec.name          = "batman-rails-flo"
  spec.version       = BatmanRailsFlo::VERSION
  spec.authors       = ["Robert Mosolgo"]
  spec.email         = ["rdmosolgo@gmail.com"]
  spec.summary       = %q{Live Reload with Batman.js and Ruby on Rails}
  spec.description   = %q{Uses Facebook's "fb-flo" package to live-update JS code.}
  spec.homepage      = "https://github.com/rmosolgo/batman-rails-flo"
  spec.license       = "MIT"

  spec.files         = Dir['{lib,vendor}/**/*', 'Rakefile', 'README.md']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", '~> 0'
end
