require 'shellwords'

module Bashly
  module Script
    class Flag < Base
      include Completions::Flag
      include Introspection::Visibility
      include Introspection::Validate

      class << self
        def option_keys
          @option_keys ||= %i[
            alias allowed arg completions conflicts default help long needs
            negatable private repeatable required short unique validate
          ]
        end
      end

      def alt
        return [] unless options['alias']

        options['alias'].is_a?(String) ? [options['alias']] : options['alias']
      end

      def aliases
        [long, negated_long, short].compact + alt
      end

      def positive_aliases
        primary_aliases + alt
      end

      def negated_long
        "--no-#{long_without_prefix}" if negatable && long
      end

      def default_string
        if default.is_a?(Array)
          Shellwords.shelljoin default
        elsif default.is_a?(String) && repeatable
          Shellwords.shellescape default
        else
          default
        end
      end

      def name
        long || short
      end

      def usage_string(extended: false)
        result = [usage_aliases.join(', ')]
        result << arg.upcase if arg
        result << strings[:required] if required && extended
        result << strings[:repeatable] if repeatable && extended
        result.join ' '
      end

    private

      def primary_aliases
        [long, short].compact
      end

      def usage_aliases
        [usage_long, short].compact + alt
      end

      def usage_long
        negatable && long ? "--[no-]#{long_without_prefix}" : long
      end

      def long_without_prefix
        long.delete_prefix '--'
      end
    end
  end
end
