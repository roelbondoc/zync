module Zync
  module Routing
    class Mapper

      class Mapping

        IGNORE_OPTIONS = [:to, :as, :via]

        def initialize(set, path, options)
          @set = set
          @options = options
          @path = normalize_path(path)
          normalize_options!
        end

        def to_route
          [ app, conditions, defaults , @options[:as] ]
        end

        def conditions
          { :path_info => @path , :request_method => request_method}
        end

        private

          def app
            Routing::RouteSet::Dispatcher.new
          end

          def normalize_path(path)
            raise ArgumentError, "path is required" if path.blank?
            path = Mapper.normalize_path(path)

            if @options[:format] == false
              @options.delete(:format)
              path
            elsif path.include?(":format")
              path
            else
              "#{path}(.:format)"
            end
          end

          def normalize_options!
            @options.merge!(default_controller_and_action)
          end

          def defaults
            @defaults ||= (@options[:defaults] || {}).tap do |defaults|
              @options.each { |k, v| defaults[k] = v unless v.is_a?(Regexp) || IGNORE_OPTIONS.include?(k) }
            end
          end

          def default_controller_and_action
            if to.is_a?(String)
              controller, action = to.split('#')
            elsif to.is_a?(Symbol)
              action = to.to_s
            end

            controller ||= @options[:controller]
            action     ||= @options[:action]

            if controller.is_a?(String) && controller =~ %r{\A/}
              raise ArgumentError, "controller name should not start with a slash"
            end

            controller = controller.to_s unless controller.is_a?(Regexp)
            action     = action.to_s     unless action.is_a?(Regexp)

            raise ArgumentError, "missing :controller" if controller.blank? && segment_keys.exclude?("controller")
            raise ArgumentError, "missing :action" if action.blank?  && segment_keys.exclude?("action")

            { :controller => controller, :action => action }.tap do |hash|
              hash.delete(:controller) if hash[:controller].blank?
              hash.delete(:action)     if hash[:action].blank?
            end
          end

          def request_method
            if(@options[:via])
              @options[:via].to_s.upcase
            else
              'GET'
            end
          end

          def segment_keys
            @segment_keys ||= Rack::Mount::RegexpWithNamedGroups.new(
              Rack::Mount::Strexp.compile(@path, {}, SEPARATORS)
            ).names
          end

          def to
            @options[:to]
          end

      end

      def self.normalize_path(path)
        Rack::Mount::Utils.normalize_path(path)
      end

      module Base

        # @private
        def initialize(set)
          @set = set
        end

        def match(path, options={})
          mapping = Mapping.new(@set, path, options || {}).to_route
          @set.add_route(*mapping)
          self
        end

        def get(*args)
          options = args.extract_options!
          options[:via] = :get
          args.push(options)
          match(*args)
          self
        end

      end

      include Base

    end
  end
end
