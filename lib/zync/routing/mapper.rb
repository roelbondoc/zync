module Zync
  module Routing
    class Mapper

      attr_reader :routes

      def initialize(set)
        @set = set
      end

      def match(route, options={})
        @set.add_route Route.new(route.keys.first, route.values.first)
        self
      end

    end
  end
end
