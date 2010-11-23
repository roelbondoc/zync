begin
  require 'bundler'
  Bundler.setup(:default, :development)
rescue LoadError => e
  # Fall back on doing an unlocked resolve at runtime.
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'zync-gen'
require 'rspec'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end