# Stub Zync dispatcher so it does not get controller references and
# simply return the controller#action as Rack::Body.
class StubDispatcher < ::Zync::Routing::RouteSet::Dispatcher
  protected
    def controller_reference(controller_param)
      controller_param
    end

    def dispatch(controller, action, env)
      [200, {'Content-Type' => 'text/html'}, ["#{controller}##{action}"]]
    end
end

def stub_controllers
  old_dispatcher = Zync::Routing::RouteSet::Dispatcher
  Zync::Routing::RouteSet.module_eval { remove_const :Dispatcher }
  Zync::Routing::RouteSet.module_eval { const_set :Dispatcher, StubDispatcher }
  yield Zync::Routing::RouteSet.new
ensure
  Zync::Routing::RouteSet.module_eval { remove_const :Dispatcher }
  Zync::Routing::RouteSet.module_eval { const_set :Dispatcher, old_dispatcher }
end
