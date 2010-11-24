module Zync
  module Generators
    class NamedBase < Base
      argument :name, :type => :string

      require_arguments!
    end
  end # Generators
  #  
end # Zync