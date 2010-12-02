# Created by James Tucker on 2008-06-19.
# Copyright 2008 James Tucker <raggi@rubyforge.org>.
# https://github.com/macournoyer/thin/blob/master/example/async_chat.ru
module Zync
  class Body
    include EventMachine::Deferrable

    def initialize
      @queue = []
      callback { flush }
    end

    def call(body)      
      @queue << body
      process_queue
    end

    def each &block
      @callback = block
      process_queue
    end

    protected

      # Ensure the queue is empty before closing a connection
      def flush
        return unless @callback

        until @queue.empty?
          Array(@queue.shift).each {|chunk| @callback.call(chunk) }
        end
      end

      def process_queue
        return unless @callback

        EM.next_tick do        
          next unless body = @queue.shift

          Array(body).each {|chunk| @callback.call(chunk) }
          process_queue unless @queue.empty?
        end
      end
  end
end