module Zync
  module Generators

    class AppBuilder
      attr_reader :options

      def initialize(generator)
        @generator = generator
        @options   = generator.options
      end

      def app
        directory 'app'
      end

      def config
        empty_directory "config"

        inside "config" do
          template "application.rb"
          template "boot.rb"
          template "environment.rb"          
          empty_directory "environments"          
          empty_directory "initializers"                    
          template "routes.rb"
          template 'settings.yml'
        end
      end

      def configru
        template "config.ru"
      end

      def gemfile
        template "Gemfile"
      end

      def lib
        empty_directory 'lib'
      end

      def log
        empty_directory 'log'

        inside "log" do
          %w( server production development test ).each do |file|
            create_file "#{file}.log"
            chmod "#{file}.log", 0666, :verbose => false
          end
        end
      end
      
      def script
        directory 'script'
        chmod "script", 0755, :verbose => false
      end
      
      def tmp
        empty_directory 'tmp'
      end
      
      def vendor
        empty_directory 'vendor'
      end

      private

        def method_missing(meth, *args, &block)
          @generator.send(meth, *args, &block)
        end

    end

    class AppGenerator < NamedBase
      Zync::Generators.add_generator(:new, self)

      def create_root
        self.destination_root = File.expand_path(name, destination_root)
        empty_directory '.'
        FileUtils.cd(destination_root)
      end

      def create_root_files
        build(:configru)
        build(:gemfile)
      end

      def create_app_files
        build(:app)
      end

      def create_config_files
        build(:config)
      end

      def create_lib_files
        build(:lib)
      end

      def create_log_files
        build(:log)
      end
      
      def create_script_files
        build(:script)
      end
      
      def create_tmp_files
        build(:tmp)
      end
      
      def create_vendor_files
        build(:vendor)
      end

      protected

        def app_const_base
          @app_const_base ||= name.gsub(/\W/, '_').squeeze('_').camelize
        end

        def app_const
          @app_const ||= "#{app_const_base}::Application"
        end

        def builder
          @builder ||= AppBuilder.new(self)
        end

        def build(meth, *args)
          builder.send(meth, *args) if builder.respond_to?(meth)
        end
    end

  end # Generators
end # Zync
