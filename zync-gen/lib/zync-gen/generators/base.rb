begin
  require 'thor/group'
rescue LoadError
  puts "Thor is not available"
  exit
end

module Zync
  module Generators

    class Error < Thor::Error
    end

    class Base < Thor::Group
      include Thor::Actions
      include Zync::Generators::Actions

      # Returns the base root for a common set of generators. This is used to dynamically
      # guess the default source root.
      def self.base_root
        File.dirname(__FILE__)
      end

      # Returns the source root for this generator using default_source_root as default.
      def self.source_root(path=nil)
        @_source_root = path if path
        @_source_root ||= default_source_root
      end

      # Returns the default source root for a given generator. This is used internally
      # by rails to set its generators source root. If you want to customize your source
      # root, you should use source_root.
      def self.default_source_root
        return unless generator_name
        path = File.expand_path(File.join(generator_name, 'templates'), base_root)
        path if File.exists?(path)
      end

      protected

        # Removes the namespaces and get the generator name. For example,
        # Zync::Generators::ModelGenerator will return "model" as generator name.
        #
        def self.generator_name
          @generator_name ||= begin
            if generator = name.to_s.split('::').last
              generator.sub!(/Generator$/, '')
              generator.underscore
            end
          end
        end

    end
  end # Generators
end #Zync
