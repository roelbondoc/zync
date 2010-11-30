module Zync
  class Logger   
    module Severity
      DEBUG   = 0
      INFO    = 1
      WARN    = 2
      ERROR   = 3
      FATAL   = 4
      UNKNOWN = 5
    end
    include Severity

    attr_accessor :level

    def initialize(adapter, level = DEBUG)
      @adapter = adapter
      @level = level
    end
   
    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s
      @adapter.add(severity, message)
      message
    end
   
    # Dynamically add methods such as:
    # def info
    # def warn
    # def debug
    for severity in Severity.constants
      class_eval <<-EOT, __FILE__, __LINE__ + 1
        def #{severity.downcase}(message = nil, progname = nil, &block) # def debug(message = nil, progname = nil, &block)
          add(#{severity}, message, progname, &block)                   #   add(DEBUG, message, progname, &block)
        end                                                             # end

        def #{severity.downcase}?                                       # def debug?
          #{severity} >= @level                                         #   DEBUG >= @level
        end                                                             # end
      EOT
    end
   
  end
end
