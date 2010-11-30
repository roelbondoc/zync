require 'em-mongo'
require 'em-synchrony'

module Zync
  module Logging
    class MongoDBLogAdapter

      attr_accessor :collection_name

      def initialize(args)
        @db = args.delete(:db)
        self.collection_name = args.delete(:collection) || 'messages'
      end

      def add(severity, message)
        @db.collection(self.collection_name).insert(:severity => severity, :text => message, :created_at => Time.now)
      end

    end
  end
end
