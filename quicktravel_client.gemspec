Gem::Specification.new do |spec|
  spec.name          = 'quicktravel_client'
  spec.version       = '1.0.0'
  spec.authors       = ['Michael Noack', 'Adam Davies', 'Alessandro Berardi']
  spec.email         = 'support@travellink.com.au'
  spec.description   = 'For integrating with QuickTravel API'
  spec.summary       = 'Booking process using QuickTravel API'
  spec.homepage      = 'https://bitbucket.org/team-sealink/quicktravel_client'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty'
  spec.add_dependency 'geokit', '~> 1.8.3' # used in address model
  spec.add_dependency 'activesupport', '>= 2.0.0'
  spec.add_dependency 'money_extensions'
  spec.add_dependency 'facets'
  spec.add_dependency 'money', '>= 3.0', '< 6.0' # 6.0 starts to deprecate/split

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-rcov'
  spec.add_development_dependency 'stamp' # Used to send appropriate dates to API's
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'fakeweb'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rubocop'
end
