module Zync
  module Routing
    class RouteSet

      attr_accessor :routes

      def initialize
        self.routes = []
      end

      def add_route(route)
        self.routes << route
        route
      end

      def call(env)
        matched_route = nil
        self.routes.each do |route|
          if route.path == env['REQUEST_PATH']            
            matched_route = route
            break
          end            
        end

        endpoint = endpoint(matched_route.endpoint) if matched_route

        if endpoint.nil?
          not_found.call(env)
        elsif endpoint.respond_to?(:call)
          endpoint.call(env)
        else
          endpoint[:controller].call(env, endpoint[:action])
        end

        # whats a better way to handle the /favicon.ico crap?
      end

      def draw(&block)
        eval_block(block)
        nil
      end

      def eval_block(block)
        mapper = Mapper.new(self)
        mapper.instance_exec(&block)
      end

      protected
        def endpoint(destination)
          controller_name, action_name = destination.split('#')
          action_name ||= 'index'
          controller = controller_klass(controller_name)
          { :controller => controller, :action => action_name.to_sym }
        end

        def controller_klass(controller_name)
          # TODO: add rescue and mention the class cannot be found
          eval((controller_name.split('_') + ['controller']).map {|x| x.capitalize}.join(''))
        end

        def not_found
          proc {|env| [404, {'Content-Type' => 'text/plain'}, 'Not found'] }
        end

    end
  end
end
