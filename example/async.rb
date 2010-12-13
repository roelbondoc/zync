# Async Rackup example
#
# Usage: ruby async.rb start

$:.unshift File.expand_path('../../lib', __FILE__)
require 'zync'

begin
  require 'thin'
rescue LoadError => ex
  $stderr.puts "Oops, couldn't find thin web server, run: gem install thin"
end

###############################################################################

class HelloWorldApp < Zync::Controller
  def index
    render "hello world"
    close
  end
end

Thin::Server.start('0.0.0.0', 3000, HelloWorldApp)
