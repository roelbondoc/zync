require 'active_support/concern'

module Zync
  module Generators
    module Actions
      extend ActiveSupport::Concern
      
      module ClassMethods

        # Tell to zync that for this Thor::Group is necessary a task to run
        def require_arguments!
          @require_arguments = true
        end

        # Return true if we need an arguments for our Thor::Group
        def require_arguments?
          @require_arguments
        end
        
      end      
    end    
  end # Generators
end # Zync