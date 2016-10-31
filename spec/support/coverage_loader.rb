MINIMUM_COVERAGE = 77.8
MAXIMUM_COVERAGE = MINIMUM_COVERAGE + 0.5

if ENV['COVERAGE'] != 'off'
  require 'simplecov'
  require 'simplecov-rcov'
  require 'coveralls'
  Coveralls.wear!

  SimpleCov.formatters = [
    SimpleCov::Formatter::RcovFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter '/vendor/'
    add_filter '/spec/'
    add_group 'lib', 'lib'
  end
  SimpleCov.at_exit do
    SimpleCov.result.format!
    percent = SimpleCov.result.covered_percent
    puts "Coverage is #{'%.2f' % percent}%"
    if percent < MINIMUM_COVERAGE
      puts "Coverage must be above #{MINIMUM_COVERAGE}%"
      Kernel.exit(1)
    elsif percent > MAXIMUM_COVERAGE
      puts "Coverage is above #{MAXIMUM_COVERAGE}%. Time to bump minimum coverage!"
      Kernel.exit(1)
    end
  end
end
