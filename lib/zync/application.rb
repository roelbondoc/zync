require 'yaml'

module Zync

  class Application
    class << self
      def instance
        Zync.application ||= new
      end
      
      def configure(&block)
        class_eval(&block)
      end
            
      protected
      
        def method_missing(*args, &block)
          instance.send(*args, &block)
        end
    end
    
    def initialize!
      load_settings
      load_app
      self
    end
    
    def call(env)
      routes.call(env)
    end

    def routes
      @routes ||= Zync::Routing::RouteSet.new
    end
    
    def load_settings
      settings_file = YAML.load(File.read("#{Zync.root}/config/settings.yml"))
      Zync.settings = (settings_file && settings_file[Zync.env]) || {}
      Zync.settings = Util.symbolize_keys(Zync.settings)
    end
    
    def load_app
      add_to_load_path "#{Zync.root}/lib"
      load_folder "#{Zync.root}/lib"
      
      load_folder "#{Zync.root}/app/controllers"
      load_folder "#{Zync.root}/config/initializers"
      load_routes
    end
    
    def load_routes
      require "#{Zync.root}/config/routes"
    end
    
    protected
    
      def load_folder(path)
        return unless File.exists?(path)
        Dir["#{path}/**/*.rb"].each {|f| require f}
      end
      
      def add_to_load_path(dir)
        $:.unshift(dir) if File.exists?(dir)
      end
    
  end
  
end
