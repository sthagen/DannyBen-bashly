module Bashly
  module Script
    class EnvironmentVariable < Base
      include Introspection::Visibility

      class << self
        def option_keys
          @option_keys ||= %i[
            allowed default help name private required validate
          ]
        end
      end

      def usage_string(extended: false)
        result = [name.upcase]
        result << strings[:required] if required && extended
        result.join ' '
      end

      def validate
        return [] unless options['validate']

        result = options['validate']
        result.is_a?(Array) ? result : [result]
      end

      def validate? = validate.any?
    end
  end
end
