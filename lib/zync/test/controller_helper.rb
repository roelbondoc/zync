module Zync
  module Test
    # RSpec helper to be included in Controller specs.
    # Inspired by Cramp's TestCase implementation. https://github.com/lifo/cramp/blob/master/lib/cramp/test_case.rb
    module ControllerHelper

      # Returns an async Rack application instance
      def app
        raise "Ensure a method 'app' is defined in your spec which returns an asynchronous Rack application"
      end

      # Retrieve the headers from an aync Rack request
      #
      # @param [String] path the target of the request
      # @param [Hash] options options to create the request with
      # @option options [Proc] :callback A proc to be executed on response
      # @param [Hash] headers headers to pass with the request
      def get(path, options = {}, headers = {}, &block)
        callback = options.delete(:callback) || block
        headers = headers.merge('async.callback' => callback)

        EM.run { request.get(path, headers) }
      end

      # Retrieve the body from an async Rack request
      # @param (see Zync::Test::ControllerHelper#get)
      def get_body(path, options = {}, headers = {}, &block)
        callback = options.delete(:callback) || block

        response_callback = proc { |response| response.last.each { |chunk| callback.call(chunk) } }
        headers = headers.merge('async.callback' => response_callback)

        EM.run { request.get(path, headers) }
      end

      # Retrieve the body from an async Rack request
      # @param (see Zync::Test::ControllerHelper#get)
      # @option options [Proc] :callback A proc to be executed on response
      # @option options [Fixnum] :count (1) The amount of chuncks to receive
      def get_body_chunks(path, options = {}, headers = {}, &block)
        callback = options.delete(:callback) || block
        count = options.delete(:count) || 1

        chunks = []
        complete = false

        get_body(path, options, headers) do |chunk|
          chunks << chunk unless complete

          if chunks.count >= count
            complete = true
            callback.call(chunks) if callback
            EM.next_tick { EM.stop }
          end
        end

      end

      # Returns a mock Rack request
      # @return [Rack::MockRequest] A mock Rack request
      def request
        @request ||= Rack::MockRequest.new(app)
      end

      # Stop the EventMachine reactor
      def stop
        EM.stop
      end

    end
  end
end
