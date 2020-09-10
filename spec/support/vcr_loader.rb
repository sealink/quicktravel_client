require 'vcr'
require 'webmock/rspec'

qt_keys = ENV['QT_KEYS'].split(',')

VCR.configure do |c|
  c.cassette_library_dir = 'spec/support/cassettes'
  c.default_cassette_options = { match_requests_on: [:method, :uri, :body] }
  c.filter_sensitive_data('<QT_KEY>')   { qt_keys[0] }
  c.filter_sensitive_data('<QT_KEY_2>') { qt_keys[1] }
  c.hook_into :webmock
  c.debug_logger = $stderr
end
