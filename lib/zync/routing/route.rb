require 'rack/mount/generatable_regexp'

module Zync
  module Routing

    class Route
      # Valid rack application to call if conditions are met
      attr_reader :app

      # A hash of conditions to match against. Conditions may be expressed
      # as strings or regexps to match against.
      attr_reader :conditions

      # A hash of values that always gets merged into the parameters hash
      attr_reader :defaults

      def initialize(app, conditions, defaults)
        unless app.respond_to?(:call)
          raise ArgumentError, 'app must be a valid rack application and respond to call'
        end

        @app = app

        @defaults = (defaults || {}).freeze

        if path = conditions[:path_info]
          @path = path
          conditions[:path_info] = ::Rack::Mount::Strexp.compile(path, {}, SEPARATORS)
        end

        # Wrap regex expressions with named capture support
        @conditions = conditions.inject({}) { |h, (k, v)|
          h[k] = ::Rack::Mount::RegexpWithNamedGroups.new(v)
          h
        }.freeze
      end

      def to_a
        [@app, @conditions, @defaults]
      end

    end
  end
end
