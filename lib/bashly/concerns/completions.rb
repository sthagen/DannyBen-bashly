require 'completely'
require 'bashly/completion_builder'

module Bashly
  # This is a `Command` and `Flag` concern responsible for providing bash
  # completion data
  module Completions
    module Flag
      def completion_data(command_full_name)
        comps = allowed || completions
        return {} unless comps

        aliases.to_h do |name|
          prefix = command_full_name
          prefix = "#{prefix}*" unless prefix.end_with? '*'
          ["#{prefix}#{name}",  comps]
        end
      end

      def completion_option_entry(token_name = nil)
        result = [aliases.join('|')]
        result << "<#{token_name}>" if token_name
        result << '(repeatable)' if repeatable
        result.join ' '
      end
    end

    module Command
      def completion_data(with_version: true)
        CompletionBuilder.new(self, with_version: with_version).call
      end

      def completion_script
        completion_generator.script
      end

      def completion_function(name = nil)
        completion_generator.wrapper_function name
      end

    private

      def completion_generator
        Completely::Completions.new completion_data
      end
    end
  end
end
