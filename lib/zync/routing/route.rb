module Zync
  module Routing
    class Route
      
      attr_accessor :path, :endpoint
      
      def initialize(path, endpoint)
        self.path = path
        self.endpoint = endpoint
      end      
            
    end    
    
  end
end