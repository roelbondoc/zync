require 'yaml'

module Zync

  class Application
    SETTINGS_FILE_PATH = "#{Zync.root}/config/settings.yml"

    class << self
      def instance
        Zync.application ||= new
      end

      def configure
        yield(self)
      end

      def settings_file=(path)
        SETTINGS_FILE_PATH.replace(path)
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
      settings_file = YAML.load(File.read(SETTINGS_FILE_PATH))
      Zync.settings = (settings_file && settings_file[Zync.env]) || {}
      Zync.settings = Util.symbolize_keys(Zync.settings)
    end

    def load_app
      add_to_load_path "#{Zync.root}/lib"
      load_folder "#{Zync.root}/lib"

      load_controllers
      load_folder "#{Zync.root}/config/initializers"
      load_routes
    end

    def load_routes
      require "#{Zync.root}/config/routes"
    end

    protected

      def load_controllers
        # Ensure ApplicationController loaded before other controllers
        load_file "#{Zync.root}/app/controllers/application_controller.rb"
        load_folder "#{Zync.root}/app/controllers"
      end

      def load_file(file)
        return unless File.exists?(file)
        require file
      end

      def load_folder(path)
        return unless File.exists?(path)
        Dir["#{path}/**/*.rb"].each {|f| require f}
      end

      def add_to_load_path(dir)
        $:.unshift(dir) if File.exists?(dir)
      end

  end

end
