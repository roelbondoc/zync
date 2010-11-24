module Zync
  module Generators
    class Cli < Thor::Group
      include Thor::Actions

      def setup       
        generator_kind  = ARGV.delete_at(0).to_s.downcase.to_sym if ARGV[0].present?
        generator_class = Zync::Generators.mappings[generator_kind]

        if generator_class
          args = ARGV.empty? && generator_class.require_arguments? ? ["-h"] : ARGV
          generator_class.start(args)
        else
          puts "FAIL"
          # TODO specify generators
        end
      end

    end
  end # Generators
end # Zync
