# Add current dir to path
$LOAD_PATH.unshift File.dirname(__FILE__)

gem 'quicktravel_client'
require 'quicktravel_client'

require 'example_config'

puts 'Login with username:'
login = gets.chomp
puts 'And password:'
password = gets.chomp

puts "Ok #{login}, just a tick..."
result = begin
  QuickTravel::Party.login(login: login, password: password)
rescue QuickTravel::AdapterError
  nil
end

if result
  puts "Ok.  You'll do this time."
else
  puts 'No go, chappy'
end
