lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick_travel/version'

Gem::Specification.new do |spec|
  spec.name          = 'quicktravel_client'
  spec.version       = QuickTravel::VERSION
  spec.authors       = ['Michael Noack', 'Adam Davies', 'Alessandro Berardi']
  spec.email         = 'support@travellink.com.au'
  spec.description   = 'For integrating with QuickTravel API'
  spec.summary       = 'Booking process using QuickTravel API'
  spec.homepage      = 'https://bitbucket.org/team-sealink/quicktravel_client'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'httparty', '>= 0.18.1'
  spec.add_dependency 'activesupport', '>= 5.0.0'
  spec.add_dependency 'facets'
  spec.add_dependency 'money', '>= 6.0'
  spec.add_dependency 'money_extensions', '>= 1.0'
  spec.add_dependency 'will_paginate'

  spec.add_development_dependency 'bundler', '~> 2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'coverage-kit'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'stamp' # Used to send appropriate dates to API's
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
end
