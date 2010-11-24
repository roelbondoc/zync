module Zync
  module Generators
    extend self
    
    autoload :Base,       'zync-gen/generators/base'
    autoload :Actions,    'zync-gen/generators/actions'
    autoload :NamedBase,  'zync-gen/generators/named_base'
    
    
    ##
    # Return a ordered list of task with their class
    #
    def mappings
      @_mappings ||= {}
    end

    ##
    # Gloabl add a new generator class to +padrino-gen+
    #
    def add_generator(name, klass)
      mappings[name] = klass
    end
    
  end
end

require 'zync-gen/generators/app'
require 'zync-gen/generators/cli'